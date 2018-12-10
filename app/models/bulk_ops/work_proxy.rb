class BulkOps::WorkProxy < ApplicationRecord
  self.table_name = "bulk_ops_work_proxies"
  belongs_to :operation, class_name: "BulkOps::Operation", foreign_key: "operation_id"
  has_many :relationships, class_name: "BulkOps::Relationship"

  attr_accessor :work_type, :visibility, :reference_identifier, :order, :proxy_errors

  def work
    @work ||= work_type.capitalize.constantize.find(work_id)
  end

  def interpret_data raw_data
    metadata = {}
    work_type = raw_data["work_type"] || operation.work_type
    visibility = raw_data["visibility"] || operation.visibility
    reference_identifier  = raw_data["reference_identifier"] || operation.reference_identifier
    order = raw_data[:order]
    raw_data.each do |field,value|
      next if field.nil? || value.nil?
      case field.downcase

      when "file", "filename"
        next if ['file','filename'].include? value
        puts "Filename: #{File.join(BulkOps::Operation::BASE_PATH,value)}"
        begin
          file = File.open(File.join(BulkOps::Operation::BASE_PATH,value))
          uploaded_file = Hyrax::UploadedFile.create(file: file, user: User.find(operation.user.id))
          (metadata[:uploaded_files] ||= []) << uploaded_file.id unless uploaded_file.id.nil?
        rescue Exception => e  
          self.status = "errors"
          self.message = "Error opening file: #{File.join(BulkOps::Operation::BASE_PATH,value)} -- #{e}"
          self.save
          (@proxy_errors ||= []) <<  message
          return false
        end

      when "collection title","collection"
        if (col = find_collection(value))
          (metadata[:member_of_collection_ids] ||= []) << col.id
        else
          BulkOps::Relationship.create({ work_proxy_id: id,
                                         identifier_type: 'title',
                                         relationship_type: "collection_title",
                                         object_identifier: value,
                                         status: "incomplete"})
        end

      when "collection id"
        if (col = find_collection(value))
          (metadata[:member_of_collection_ids] ||= []) << col.id
        else
          BulkOps::Relationship.create({ work_proxy_id: proxy.id,
                                         identifier_type: 'id',
                                         relationship_type: "collection_id",
                                         object_identifier: value,
                                         status: "incomplete"})
        end

      when "parent", "child", "next"
        # This field specifies a relationship. 
        # Log this relationship in the database for future processing
        # allow for customized identifier types
        # using the notation "id:a78C2d81"
        if((split = value.split(":")).count == 2)
          reference_identifier = split[0]
          value = split[1]
        end
        BulkOps::Relationship.create({ work_proxy_id: proxy.id,
                                       identifier_type: reference_identifier,
                                       relationship_type: field.downcase,
                                       object_identifier: value,
                                       status: "incomplete"})

      when *(operation.ignored_fields)
      # Ignore this i.e. do nothing

      else
        # this is presumably a normal metadata field

        # if the field name is not a valid metadata element, 
        # check if it is the label of a valid element
        property_name = format_param_name(field)
        if schema["labels"][property_name] && !work_type.camelize.constantize.new.responds_to?(property_name)
          property_name = schema["labels"][property_name] 
        end

        next unless schema["properties"][property_name]

        if schema["properties"][property_name]["controlled"]
          url = (value =~ URI::regexp) ? value : localAuthUrl(property_name, value)
          metadata["#{property_name}_attributes"] ||= []
          metadata["#{property_name}_attributes"] << {id: url}
        else
          (metadata[property_name] ||= []) << value.strip.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_') unless value.blank?
        end
      end
    end
    
    asets = AdminSet.where({title: "Bulk Ingest Set"})
    unless metadata[:admin_set_id] or asets.empty?
      metadata[:admin_set_id] = asets.first.id
    end
    return metadata
  end


  def work_type
    @work_type ||= (operation.work_type || "Work")
  end


  def localAuthUrl(property, value) 
    return value if (auth = getLocalAuth(property)).nil?
    return (url = findAuthUrl(auth, value)) ? url : mintLocalAuthUrl(auth,value)
  end


  private 

  def find_collection(collection)
    cols = Collection.where(id: collection)
    cols += Collection.where(title: collection)
    return cols.first unless cols.empty?
    return false
  end

  def format_param_name(name)
    name.titleize.gsub(/\s+/, "").camelcase(:lower)
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA["work_types"][work_type.downcase]
  end


  def mintLocalAuthUrl(auth_name, value) 
    id = value.parameterize
    auth = Qa::LocalAuthority.find_or_create_by(name: auth_name)
    Qa::LocalAuthorityEntry.create(local_authority: auth,
                                   label: value,
                                   uri: id)
    return localIdToUrl(id,auth_name)
  end

  def findAuthUrl(auth, value)
    return nil if auth.nil?
    return nil unless (entries = Qa::Authorities::Local.subauthority_for(auth).search(value))
    entries.each do |entry|
      #require exact match
      if entry["label"] == value
        url = entry["url"]
        url ||= entry["id"]
        url = localIdToUrl(url,auth) unless url =~ URI::regexp
        return url
      end
    end
    return nil
  end

  def localIdToUrl(id,auth_name) 
    return "https://digitalcollections.library.ucsc.edu/authorities/show/local/#{auth_name}/#{id}"
  end

  def getLocalAuth(property)
    if vocs = schema["properties"][property]["vocabularies"]
      vocs.each do |voc|
        return voc["subauthority"] if voc["authority"].downcase == "local"
      end
    elsif voc = schema["properties"][property]["vocabulary"]
      return voc["subauthority"] if voc["authority"].downcase == "local"
    end
    return nil
  end




end

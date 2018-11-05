require 'uri'
require 'socket'

class BulkMetadata::Row < ApplicationRecord

  attr_accessor :work_type

  self.table_name = "bulk_meta_rows"

  BASE_PATH = "/dams_ingest"
  belongs_to :ingest 
  has_many :cells
  has_many :relationships

  def schema
    ScoobySnacks::METADATA_SCHEMA["work_types"][work_type.downcase]
  end

  def work_type
    @work_type ||= ingest.work_type
  end

  def reparse
    row_hash = CSV.parse(ingest.get_csv([id]),headers:true).first
    cells.each{ |cell| cell.destroy! }
    createNewCells!(row_hash)
  end

  def createNewCells!(row_hash)
    row_hash.each do |property,values|
      next if values.nil?
      row_errors = []
      values.split(';').each do |value|

        if schema["properties"][property] && schema["properties"][property]["controlled"]
          url = (value =~ URI::regexp) ? value : localAuthUrl(property, value)
          cell = cells.find_by(name: property, value_url: url )
          cell ||= self.cells.create(name: property, value_url: url, value: value, status: "pending")
        else
          cell = cells.find_by(name: property, value: value )
          cell ||= self.cells.create(name: property, value: value, status: "pending") 
        end
      end
    end
  end


  def localAuthUrl(property, value) 
    return value if (auth = getLocalAuth(property)).nil?
    return (url = findAuthUrl(auth, value)) ? url : mintLocalAuthUrl(auth,value)
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

    
  def ingest!(user_email)
    user = User.find_by_email(user_email)
    metadata = {}

    #presume a new work unless we hear otherwise
    edit_id = nil;
    @work_type = ingest.work_type
    id_type = ingest.relationship_identifier
    visibility = ingest.visibility

    cells.each do |cell|
      next if cell.value.blank?

      ignore = ingest.ignore.nil? ? "" : ingest.ignore

      case cell.name.downcase
      when "file", "filename"
        begin
          file = File.open(File.join(BASE_PATH,cell.value))
          uploaded_file = Hyrax::UploadedFile.create(file: file, user: user)
          (metadata[:uploaded_files] ||= []) << uploaded_file.id if !uploaded_file.id.nil?
        rescue Exception => e  
          self.status = "Error: Cannot open file: #{File.join(BASE_PATH,cell.value)}, #{e.message}"
          self.save
          return false
        end

      when "collection title","collection"
        if (col = find_collection(cell.value))
          (metadata[:member_of_collection_ids] ||= []) << col.id
        else
          relationships.build({ :relationship_type => 'collection',
                                :identifier_type => 'title',
                                :object_identifier => cell.value,
                                :status => "incomplete"})
        end

      when "collection id"
        if (col = find_collection(cell.value))
          (metadata[:member_of_collection_ids] ||= []) << col.id
        else
          relationships.build({ :relationship_type => 'collection_id',
                                :identifier_type => 'id',
                                :object_identifier => cell.value,
                                :status => "incomplete"})
        end

      when "parent", "child"
        # This cell specifies a relationship. 
        # Log this relationship in the database for future processing
        # allow for cell-specific identifier types
        # using the notation "id:a78C2d81"
        if(cell.value.include?(":"))
          split = cell.value.split(":")
          id_type = split[0]
          object_id = split[1]
        else
          object_id = cell.value              
        end

        relationships.build({ :relationship_type => cell.name.downcase,
                              :identifier_type => id_type,
                              :object_identifier => object_id,
                              :status => "incomplete"})
      when "work type"
        # set the work type for this item
        # overriding the default set for the whole ingest
        @work_type = cell.value
        
      when "visibility"
        # set the work type for this item
        # overriding the default set for the whole ingest
        visibility = cell.value

      when "relationship identifier type"
        # set the relationship identifier type for this item
        # overriding the default set for the whole ingest
        id_type = cell.value
        
      when "id"
        # I want to only use id to pick out works to edit
        # so edit_identifier can become a boolean flag
        if ingest.edit_identifier == "id"
          # we are editing an existing work
          edit_id = cell.value
        else
          
        end
      when *(ignore.split(/[,;:]/))
      # Ignore this i.e. do nothing
      else
        # this is presumably a normal metadata field

        # if the cell name is not a valid metadata element, 
        # check if it is the label of a valid element
        property_name = format_param_name(cell.name)
        if schema["labels"][property_name] && !@work_type.camelize.constantize.new.responds_to?(property_name)
          property_name = schema["labels"][property_name] 
        end

        next unless schema["properties"][property_name]

        if schema["properties"][property_name]["controlled"]
          value = cell.value_url ? cell.value_url : cell.value
          
          metadata["#{property_name}_attributes"] ||= []
          metadata["#{property_name}_attributes"] << {id: value.strip}
        else
          (metadata[property_name] ||= []) << cell.value.strip if !cell.value.blank?
        end
      end
    end

    #update status
    self.status = "ingesting"
    save

    asets = AdminSet.where({title: "Bulk Ingest Set"})
    unless metadata[:admin_set_id] or asets.empty?
      metadata[:admin_set_id] = asets.first.id
    end

    if edit_id.nil?
      UcscCreateWorkJob.perform_later(@work_type,user_email,metadata,id,visibility)
    else
      UcscEditWorkJob.perform_later(edit_id,@work_type,user,metadata,id,visibility)
    end
  end

  def format_param_name(name)
    name.titleize.gsub(/\s+/, "").camelcase(:lower)
  end

  def find_collection(collection)
    cols = Collection.where(id: collection)
    cols += Collection.where(title: collection)
    return cols.first unless cols.empty?
    return false
  end

  def ingested_work
    return nil if ingested_id.nil?
    work_type.camelize.constantize.find(ingested_id)
  end

  def title
    return "Untitled Row" if cells.where(:name =>"title").empty?
    cells.where(:name => "title").first.value
  end

  def info
    summary_fields = ["title","description","creator","subject","date_created","abstract"]
    info = {}
    cells.each do |cell|
      if summary_fields.include? cell.name.downcase
        info[cell.name] = cell.value
      end
    end
    return info
  end

end

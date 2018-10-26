class BulkOps::Operation < ApplicationRecord
  belongs_to :user
  has_many :work_proxys
  self.table_name = "bulk_ops_operations"

  def apply!
    status = "#{type}ing"
    stage = "running"
    message = "#{type.titleize} initiated by #{current_user.name || current_user.email}"
    save
    
    get_spreadsheet
    
    apply_ingest! if ingest?
    apply_update! if update?


    #loop through work proxies
    work_proxies.each |proxy| do
      
      

    end

    #  create background jobs for each
    #  
  end

  def apply_ingest! spreadsheet
    #destroy existing work proxies for an ingest. Create from current spreadsheet only.
    work_proxys.each{|proxy| proxy.destroy!}

    #create a work proxy for each row in the spreadsheet
    @metadata.each_with_index do |values,row_number|
      proxy = work_proxies.create(status: "queued",
                                  last_event: DateTime.now,
                                  row_number: row_number,
                                  message: "Placeholder during ingest initiated by #{current_user.name || current_user.email}")
    end

    #loop through the work proxies to create a job for each work
    work_proxies.each do |proxy|
      data = interpret_data(spreadsheet[proxy.row_number])
      work_type = data['work_type'] || @work_type
      work_type ||= 'Work'
      visibility = data['visibility'] || @visibility
      visibility ||= 'restricted'
      BulkOps.IngestJob.perform_later(work_type,current_user.email,data,proxy.id,visibility)
    end
  end

  def apply_update! spreadsheet
    @metadata.each_with_index do |values,row_number|
      proxy = BulkOps::WorkProxy.find_by(operation_id: id, work_id: values["work_id"])
      #todo throw & log appropriate exeption if work_id column not found or work referred to not found
      
      proxy.status = "updating"
      proxy.message = "update initiated by #{current_user.name || current_user.email}"
      proxy.save
    end

    #loop through the work proxies to create a job for each work
    work_proxies.each do |proxy|
      data = interpret_data(spreadsheet[proxy.row_number])
      visibility = data['visibility'] || @visibility
      BulkOps.UpdateJob.perform_later(proxy.id,data,current_user.email,visibility)      
    end
  end

  def create_branch(fields: fields, work_ids: work_ids, options: options)
    work_ids ||= []
    fields ||= default_metadata_fields

    begin
      git.create_branch!

      #copy template files
      Dir["#{Rails.root}/lib/bulk_operations/templates/*"].each do |template_file_path| 
        git.add_file "#{name}/#{template_file_path}" 
      end

      #update configuration options      
      new_options = YAML.load_file("lib/bulk_operations/templates/configuration.yml")
      options.each { |option, value| new_options[option] = value } unless options.nil?
      git.update_options new_options

      #add metadata spreadsheet
      @metadata = self.works_to_csv(work_ids, fields)
      git.add_contents "#{name}/metadata.csv", metadata, branch: name
    rescue
      false
    end

  end

  def self.works_to_csv work_ids, fields
    work_ids.reduce(fields.join(',')){|csv, work_id| csv + "\r\n" + self.work_to_csv(work_id,fields)}
  end

  def get_spreadsheet
    @metadata ||= git.load_metadata
  end

  def update_spreadsheet filename, message=false
    git.update_spreadsheet(filename, message)
  end

  def options
    @options ||= git.load_options
  end

  def set_options options, message = false
    @options = options
    git.set_options(options, message)
  end

  def draft?
    return (stage == 'draft')
  end

  def running?
    return (stage == 'running')
  end

  def ingest?
    type == "ingest"
  end

  def update?
    type == "update"
  end

  def destroy!
    git.delete_branch(name)
    super
  end

  def destroy
    git.delete_branch(name)
    super
  end

  private

  def git
    @git ||= BulkOps::GithubAccess.new(name)
  end

  def self.work_to_csv work_id, fields
    work = Work.find(work_id)
    line = ''
    fields.map do |field_name| 
      label = false
      if field_name.downcase.include? "label"
        label = true
        field_name = field_name[0..-7]
      end
      values = self.call(field_name)
      values.map do |value|
        value = (label ? WorkIndexer.fetch_remote_label(value.id) : value.id) unless value.is_a? String
        '"#{value.gsub("\"","\"\"")}"'
      end.join(',')
    end
  end

  def self.filter_fields fields, label = true
    fields.each do |field_name, field|
      # reject if not in scoobysnacks
      # add label if needed
    end
  end

  def default_metadata_fields labels = true
    #returns full set of metadata parameters from ScoobySnacks to include in ingest template spreadsheet    
    fields = []
#    ScoobySnacks::METADATA_SCHEMA.fields.each do |field_name,field|
    ScoobySnacks::METADATA_SCHEMA['work_types']['work']['properties'].each do |field_name,field|
      fields << field_name
      fields << "#{field_name} Label" if labels && field["controlled"]
    end
    return fields
  end

  def ignored_fields
    options['ignored_fields']
  end
  
  def interpret_data raw_data
    metadata = []
    raw_data.each do |field,value|
      case field.downcase

      when "file", "filename"
        begin
          file = File.open(File.join(BASE_PATH,value))
          uploaded_file = Hyrax::UploadedFile.create(file: file, user: user)
          (metadata[:uploaded_files] ||= []) << uploaded_file.id if !uploaded_file.id.nil?
        rescue Exception => e  
          self.status = "Error: Cannot open file: #{File.join(BASE_PATH,value)}, #{e.message}"
          self.save
          return false
        end

      when "collection title","collection"
        if (col = find_collection(value))
          (metadata[:member_of_collection_ids] ||= []) << col.id
        else
          relationships.build({ :relationship_type => 'collection',
                                :identifier_type => 'title',
                                :object_identifier => value,
                                :status => "incomplete"})
        end

      when "collection id"
        if (col = find_collection(value))
          (metadata[:member_of_collection_ids] ||= []) << col.id
        else
          relationships.build({ :relationship_type => 'collection_id',
                                :identifier_type => 'id',
                                :object_identifier => value,
                                :status => "incomplete"})
        end

      when "parent", "child"
        # This field specifies a relationship. 
        # Log this relationship in the database for future processing
        # allow for customized identifier types
        # using the notation "id:a78C2d81"
        id_type = "work_id"
        if(value.include?(":"))
          split = value.split(":")
          id_type = split[0]
          object_id = split[1]
        else
          object_id = value              
        end

        relationships.build({ :relationship_type => field.downcase,
                              :identifier_type => id_type,
                              :object_identifier => object_id,
                              :status => "incomplete"})
      when "work type"
        # set the work type for this item
        # overriding the default set for the whole operation
        @work_type = value
        
      when "visibility"
        # set the work type for this item
        # overriding the default set for the whole ingest
        @visibility = value

      when "relationship identifier type"
        # set the work type for this item
        # overriding the default set for the whole ingest
        @id_type = value
        
      when "id"
        # I want to only use id to pick out works to edit
        # so edit_identifier can become a boolean flag
        if ingest.edit_identifier == "id"
          # we are editing an existing work
          edit_id = value
        else
          
        end
      when *(ignored_fields.split(/[,;:]/))
      # Ignore this i.e. do nothing
      else
        # this is presumably a normal metadata field

        # if the field name is not a valid metadata element, 
        # check if it is the label of a valid element
        property_name = format_param_name(field)
        if schema["labels"][property_name] && !@work_type.camelize.constantize.new.responds_to?(property_name)
          property_name = schema["labels"][property_name] 
        end

        next unless schema["properties"][property_name]

        if schema["properties"][property_name]["controlled"]
          metadata["#{property_name}_attributes"] ||= []
          metadata["#{property_name}_attributes"] << {id: value.strip}
        else
          (metadata[property_name] ||= []) << value.strip if !value.blank?
        end
      end
    end
    
    asets = AdminSet.where({title: "Bulk Ingest Set"})
    unless metadata[:admin_set_id] or asets.empty?
      metadata[:admin_set_id] = asets.first.id
    end
    metadata
  end
end



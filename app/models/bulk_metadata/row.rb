class BulkMetadata::Row < ApplicationRecord

  self.table_name = "bulk_meta_rows"

  BASE_PATH = "/avalon2sufia/inbox"
  belongs_to :ingest 
  has_many :cells
  has_many :relationships

  def schema
    ScoobySnacks::METADATA_SCHEMA["work_types"][ingest.work_type.downcase]
  end

  def parse
    #TODO
    #this method only applies if the text of the row is edited after failure
    #parse self.text
    #make sure it matches up with headers array
    #(get array headers from parent csv file if necessary)
    #update status
    #create log
    #return parsed array
  end

  def updateText(text)
    #TODO check whether this is stupid (there is a convention for this)
    #log event
    #update text
  end

  def createNewCells!(row_hash)
    puts "work_type: #{ingest.work_type}"
    puts "schema: #{schema.to_s}"
    row_hash.each do |property,values|
      next if values.nil?
      row_errors = []
      values.split(';').each do |value|

        if schema["properties"][property] && schema["properties"][property]["controlled"]
          cell = cells.find_by(name: property, value_url: value )
          cell ||= self.cells.create(name: property, value_url: value, value: value, status: "pending")
        else
          cell = cells.find_by(name: property, value: value )
          cell ||= self.cells.create(name: property, value: value, status: "pending") 
        end
      end
    end
  end

  #special cell types:
  #file
  #relationship (parent, child)
  #work type
  #edit identifier
  #ignore

  def ingest!(user_email)
    user = User.find_by_email(user_email)
    metadata = {}

    #presume a new work unless we hear otherwise
    edit_id = nil;
    work_type = ingest.work_type
    id_type = ingest.relationship_identifier
    visibility = ingest.visibility

    wrk = work_type.camelize.constantize.new

    cells.each do |cell|
      next if cell.value.blank?

      ignore = ingest.ignore.nil? ? "" : ingest.ignore

      case cell.name.downcase
      when "file", "filename"
        begin
          file = File.open(File.join(BASE_PATH,cell.value))
          uploaded_file = Hyrax::UploadedFile.create(file: file, user: user)
          (metadata[:uploaded_files] ||= []) << uploaded_file.id if !uploaded_file.id.nil?
        rescue
          self.status = "Error: Cannot open file"
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
        relationships.build({ :relationship_type => 'collection_id',
                              :identifier_type => 'id',
                              :object_identifier => cell.value,
                              :status => "incomplete"})

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
        work_type = cell.value
        
      when "visibility"
        # set the work type for this item
        # overriding the default set for the whole ingest
        visibility = cell.value

      when "relationship identifier type"
        # set the work type for this item
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
        if schema["labels"][property_name] && !wrk.responds_to?(property_name)
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
      UcscCreateWorkJob.perform_later(work_type,user_email,metadata,id,visibility)
    else
      UcscEditWorkJob.perform_later(edit_id,work_type,user,metadata,id,visibility)
    end
  end

  def format_param_name(name)
    name.titleize.gsub(/\s+/, "").camelcase(:lower)
  end

  def find_collection(collection)
    cols = Collection.where(id: collection)
    cols += Collection.where(title: collection)
    return cols.first unless cols.empty
    return false
  end

  def ingested_work
    return false if !@work_id
    work_type.camelize.constantize.find(@work_id)
  end

  def set_work_id(work_id)
    @work_id = work_id
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

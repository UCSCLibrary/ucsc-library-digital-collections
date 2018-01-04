class BulkMetadata::Row < ApplicationRecord
  self.table_name = "bmi_rows"

  BASE_PATH = "/avalon2sufia/inbox"
  belongs_to :ingest 
  has_many :cells
  has_many :relationships

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
    row_hash.each do |property,values|
      next if values.nil?
      row_errors = []
      values.split(';').each do |value|
        cell = cells.find_by(name: property, value_string: value )
        if cell.nil?
          cell = cells.find_by(name: property, value_url: value )
        end
        if cell.nil?
          #it is a new cell
          cell = self.cells.create(name: property, value_string: value, status: "pending")
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
    labels = ScoobySnacks::METADATA_SCHEMA["work_types"][work_type]["labels"]

    wrk = work_type.camelize.constantize.new

    cells.each do |cell|
      next if cell.value_string.blank?

      ignore = ingest.ignore.nil? ? "" : ingest.ignore

      case cell.name.downcase
          when "file", "filename"
            file = File.open(File.join(BASE_PATH,cell.value_string))
            uploaded_file = Hyrax::UploadedFile.create(file: file, user: user)
            (metadata[:uploaded_files] ||= []) << uploaded_file.id if !uploaded_file.id.nil?

          when "collection title","collection"
            relationships.build({ :relationship_type => 'collection',
                                      :identifier_type => 'title',
                                      :object_identifier => cell.value_string,
                                      :status => "incomplete"})

          when "collection id"
            relationships.build({ :relationship_type => 'collection_id',
                                      :identifier_type => 'id',
                                      :object_identifier => cell.value_string,
                                      :status => "incomplete"})

          when "parent", "child"
            # This cell specifies a relationship. 
            # Log this relationship in the database for future processing
            # allow for cell-specific identifier types
            # using the notation "id:a78C2d81"
            if(cell.value_string.include?(":"))
              split = cell.value_string.split(":")
              id_type = split[0]
              object_id = split[1]
            else
              object_id = cell.value_string              
            end

            relationships.build({ :relationship_type => cell.name.downcase,
                                      :identifier_type => id_type,
                                      :object_identifier => object_id,
                                      :status => "incomplete"})
          when "work type"
            # set the work type for this item
            # overriding the default set for the whole ingest
            work_type = cell.value_string
          
          when "visibility"
            # set the work type for this item
            # overriding the default set for the whole ingest
            visibility = cell.value_string

          when "relationship identifier type"
            # set the work type for this item
            # overriding the default set for the whole ingest
            id_type = cell.value_string
            
          when "id"
            # I want to only use id to pick out works to edit
            # so edit_identifier can become a boolean flag
           if ingest.edit_identifier == "id"
              # we are editing an existing work
              edit_id = cell.value_string
           else
             

           end
          when *(ignore.split(/[,;:]/))
            # Ignore this i.e. do nothing
          else
            # this is presumably a normal metadata field

            # if the cell name is not a valid metadata element, 
            # check if it is the label of a valid element
            property_name = cell.name.parameterize.underscore
            if labels[property_name] && !wrk.responds_to?(property_name)
              property_name = labels[property_name] 
            end
            (metadata[cell.name.parameterize.underscore] ||= []) << cell.value_string if !cell.value_string.blank?
    
      end
    end

    #update status
    self.status = "ingesting"
    save

    if edit_id.nil?
      UcscCreateWorkJob.perform_later(work_type,user.email,metadata,id,visibility)
    else
      UcscEditWorkJob.perform_later(edit_id,work_type,user,metadata,id,visibility)
    end
  end

  def ingested_work
    return false if !work_id
    work_type.camelize.constantize.find(work_id)
  end

  def title
    return "Untitled Row" if cells.where(:name =>"title").empty?
    cells.where(:name => "title").first.value_string
  end

  def info
    summary_fields = ["title","description","creator","subject","date_created","abstract"]
    info = {}
    cells.each do |cell|
      if summary_fields.include? cell.name.downcase
        info[cell.name] = cell.value_string
      end
    end
    return info
  end

end

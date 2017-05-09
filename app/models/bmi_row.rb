class BmiRow < ApplicationRecord
  BASE_PATH = "/avalon2sufia/inbox"
  belongs_to :bmi_ingest 
  has_many :bmi_cells
  has_many :bmi_relationships

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
    #TODO check if this is stupid (there is a convention for this)

    #log event
    #update text
  end

  def createNewCells!(row_hash)
    row_hash.each do |property,values|
      next if values.nil?
      row_errors = []
      values.split(';').each do |value|
        cell = bmi_cells.find_by(name: property, value_string: value )
        if cell.nil?
          cell = bmi_cells.find_by(name: property, value_url: value )
        end
        if cell.nil?
          #it is a new cell
          cell = self.bmi_cells.create(name: property, value_string: value, status: "pending")
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

  def ingest!(user)
    #TODO THIS SHOULD NEVER DEFAULT TO ME IN PRODUCTION
    metadata = {}
#    work_type = @bmi_ingest.work_type
    bmi_cells.each do |cell|
      next if cell.value_string.blank?
      case cell.name.downcase
          when "file"
            file = File.open(File.join(BASE_PATH,cell.value_string))
            uploaded_file = Sufia::UploadedFile.create(file: file, user: user)
            (metadata[:uploaded_files] ||= []) << uploaded_file.id if !uploaded_file.id.nil?
          when "parent"
          when "child"
          when "work type"
#todo: when @bmi_ingest.ignore
#todo: when @bmi_ingest.edit_identifier
          else
            (metadata[cell.name] ||= []) << cell.value_string if !cell.value_string.blank?
    
      end
    end

    #update status
    self.status = "ingesting"
    save
    #start create_work job
    UcscCreateWorkJob.perform_later("Work",user,metadata,id)
    #TODO create log
  end

  def title
    return "Untitled Row" if bmi_cells.where(:name =>"title").empty?
    bmi_cells.where(:name => "title").first.value_string
  end

  def info
    summary_fields = ["title","description","creator","subject","date_created","abstract"]
    info = {}
    bmi_cells.each do |cell|
      if summary_fields.include? cell.name.downcase
        info[cell.name] = cell.value_string
      end
    end
    return info
  end

end

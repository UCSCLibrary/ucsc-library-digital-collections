class BmiRow < ApplicationRecord
  belongs_to :bmi_ingest 
  has_many :bmi_cells

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
    row_hash.each do |property,value|
      row_errors = []
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

  def ingest!(user=User.first)
    #TODO THIS SHOULD NEVER DEFAULT TO ME IN PRODUCTION
    metadata = {}
    bmi_cells.each do |cell|
      if cell.name == "file" && !cell.value_string.blank?
        file = File.open(File.join(BASE_PATH,cell.value_string.blank?))
        uploaded_file = Sufia::UploadedFile.create(file: file, user: user)
        (metadata[:uploaded_files] ||= []) << uploaded_file.id if !uploaded_file.id.nil?
      else
        (metadata[cell.name] ||= []) << cell.value_string if !cell.value_string.blank?    
      end
    end
    #start create_work job
    UcscCreateWorkJob.perform_later("Work",user,metadata)
    #update status
    status = "ingesting"
    save
    #TODO create log
  end

end

class BmiIngest < ApplicationRecord
  belongs_to :user
  has_many :bmi_rows
  enum status: [ :pending, :checking, :check_passed, :check_failed, :processing, :completed, :completed_with_errors, :failed ]

  def self.create_new(params)
    instance = self.new(params);
    instance.status = "pending"
    instance.class_name = "Work"
    instance.save
    instance.setFile(params[:file])
    instance
  end

  def parse
    #create log for parsing file
    #validate file
    #parse first line as header array
    #log any errors in this parsing
    #if valid header, loop through file lines
    #skip any line previously parsed correctly
    #create a row and a log entry for each line
    #if a row parses correctly, create cells
    #return status, error list & valid row/cell array.
  end

  def setFile(uploaded_file)
    #save csv file to permanent location
    save_as = File.join( Rails.root, 'public', 'uploads','batch_metadata_ingests',self.id.to_s + "_" + uploaded_file.original_filename)
    File.open( save_as.to_s, 'w' ) do |file|
      file.write( uploaded_file.read )
    end
    self.filename = save_as
  end

  def numUnparsed
#    BmiRow.find_by(bmi_ingest_id:self.id)
    return 0
  end

  def numParsed
    return 0
  end

  def numErrors
    return 0
  end

  def numIngested
    return 0
  end

  def parseHeader(headerString)
    #return ordered array of valid predicates 
    # or create log entry & return error message
  end

  def ingest
    #for each correctly parsed row
    # issue a create work job
  end

  def log!(type,subtype,message,row_id=null,cell_id=null)
    
  end
end

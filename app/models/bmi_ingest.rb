class BmiIngest < ApplicationRecord
  belongs_to :user
  has_many :bmi_rows
  enum status: [ :pending, :checking, :check_passed, :check_failed, :processing, :completed, :completed_with_errors, :failed ]
  require 'csv'   

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
    log!("ingest","parse","Parsing ingest #"+id+" filename:"+filename)
    #this array tracks parsed records
    parsed = []
    #validate file
    csv_text = File.read(filename)
    csv = CSV.parse(csv_text, :headers => true)
    #TODO validate csv.headers 
    # abort if this returns false
    parseHeaders(csv.headers)
    
    #Create Row
    rows = self.rows
    csv.each do |key,value|
      next if value.blank?
      #skip any line previously parsed correctly
      #loop through the existing rows for this ingest
      this_row = nil;
      rows.each do |row|
        next if row.text.slice(0,1000) != text.slice(1000)
        next if row.text.slice(0,5000) != text.slice(5000)
        this_row = row
      end
      if this_row.nil?
        this_row = self.rows.create(status: "new",text: text)
        parsed[this_row.id] = []
      else
        next if this.row.status == "parsed" || this.row.status == "ingested"
      end

      #Create Cells
      #TODO: try - catch here
      cells = this_row.cells
      row_data = this_row.parse
      row_data.each do |property,value|
        row_errors = []
        this_cell = nil;
        cells.each do |cell|
          next if cell.name != property
          next if cell.value_string != value && cell.value_url != value
          this_cell = cell
        end
        if this_cell.nil?
          this_cell = this_row.cells.create(name: property, value_string: value, status: "new")
          parsed[this_row.id] = this_cell.id
        end
      end
    end
    return parsed
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

  def parseHeaders(headers)
    # each should correspond to a valid property
    # log any errors 
  end

  def ingest
    #for each correctly parsed row
    # issue a create work job
  end

  def log!(type,subtype,message,row_id=null,cell_id=null)
    
  end
end

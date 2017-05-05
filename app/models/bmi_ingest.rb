class BmiIngest < ApplicationRecord
  belongs_to :user
  has_many :bmi_rows

#  enum status: [:unparsed, :checking, :check_passed, :check_failed, :processing, :completed, :completed_with_errors, :failed ]
  require 'csv'   

  def self.create_new(params)
    instance = self.new(params.except(:file));
    instance.status = "unparsed"
    instance.class_name = "Work"
    instance.save
    instance.setFile(params[:file])
    instance.parse
    instance
  end

  def headers
    return @headers if !@headers.blank?
    csv_text = File.read(filename)
    csv = CSV.parse(csv_text, :headers => true)
    @headers = csv.headers
  end

  def parseChanged
    this.rows.where(status: "edited").each do |row|
      row.parse
    end
  end

  def parse
    #create log for parsing file
#   log!("ingest","parse","Parsing ingest #"+id+" filename:"+filename)
    #validate file
    csv_text = parseIngestSpec(File.read(filename))

    csv = CSV.parse(csv_text, :headers => true)
    #TODO validate csv.headers 
    # abort if this returns false
    # (currently does nothing)
    parseHeaders(csv.headers)
    
    #Create Row
    csv.each do |row|
      #This will store the persistent row object
      bmi_row = bmi_rows.find_by(text: row.to_s)
      
      if bmi_row.nil?
         # we have no row record for this yet
        bmi_row = bmi_rows.create(status: "unparsed",text: row.to_s)
      else
        # we already have a row record
        #If the row is already parsed, move to the next row
        next if bmi_row.status == "parsed" || bmi_row.status == "ingested"
        #otherwise we proceed with the existing row record
      end

      #Create Cells
      #todo try/catch here
      #return newly parsed cells
      new_cells = bmi_row.createNewCells!(row) 

      #should be in success block of try/catch:
      bmi_row.status = "unparsed"
      bmi_row.save
    end
  end

  def setFile(uploaded_file)
    #save csv file to permanent location
    save_as = File.join( Rails.root, 'public', 'uploads','batch_metadata_ingests',self.id.to_s + "_" + uploaded_file.original_filename)
    File.open( save_as.to_s, 'w' ) do |file|
      file.write( uploaded_file.read) 
    end
    self.filename = save_as
  end

  def get_basic_info( type = "all" )
    case(type)
        when "unparsed"
          
        when "parsed"

        when "ingesting"

        when "error"

        when "ingested"

        when "all"

        else

    end
  end

  def numUnparsed
    return bmi_rows.where(status:"unparsed").count unless bmi_rows.empty?
    csv_text = parseIngestSpec(File.read(filename))
    csv_text.lines.count - 1;
  end

  def numParsed
    bmi_rows.where(status:"parsed").count
  end

  def numErrors
    bmi_rows.where(status:"error").count
  end

  def numIngesting
    bmi_rows.where(status:"ingesting").count
  end

  def numIngested
    bmi_rows.where(status:"ingested").count
  end

  def parseHeaders(headers)
    # each should correspond to a valid property
    # log any errors 
  end

  def hasSpecLine? 
    csv_text = File.read(filename)
    spec = csv_text.lines.first
    spec.downcase.include? "ingest name"
  end

  def parseIngestSpec(csv) 
    spec = csv.lines.first
    if !spec.downcase.include? "ingest name"
      return csv
    end
    spec_elements = spec.split(",");
    spec_elements.each do |spec_key, index|
      next if index.odd?
      spec_value = spec_elements[index+1]

      case spec_key.downcase
          when "ingest name"
            this.name = spec_value
          when "relationship identifier"
            this.relationship_identifier = spec_value
          when "edit identifier"
            this.edit_identifier = spec_value
          when "replace files"
            this.replace_files = spec_value
          when "visibility"
            this.visibility = spec_value
          when "notifications"
            this.notifications = spec_value
          when "ignore"
            this.ignore = spec_value
      end
      this.save
      return csv.to_a[1..-1].join
    end

  end

  def ingest
    #for each correctly parsed row
    # call row.ingest!
  end

  def log!(type,subtype,message,row_id=null,cell_id=null)
    
  end
end

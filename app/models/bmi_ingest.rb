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


  def get_csv(row_ids = "all")
    if row_ids == "all" || row_ids.nil? || row_ids.empty?
      rows = bmi_rows
    else
      rows = row_ids.map {|id| BmiRow.find(id) }
    end

    rows.reduce(headertext) {|csv,newrow| csv+"\n"+newrow.text}
  end

  def headers
    return @headers if !@headers.blank?
    return false if !File.exists(filename)
    csv_text = File.read(filename)
    csv = CSV.parse(csv_text, :headers => true)
    @headers = csv.headers
  end

  def headertext
    return false if !File.exists(filename)
    File.read(filename).lines.first
  end

  def parseChanged
    this.rows.where(status: "edited").each do |row|
      row.parse
    end
  end

  def parse
<<<<<<< HEAD

    #validate file
    csv_text = File.read(filename)
    row_index_offset = 2
    if (hasSpecLine?)
      csv_text = parseIngestSpec(file_text)
      row_index_offset += 1
    end
=======
    #create log for parsing file
#   log!("ingest","parse","Parsing ingest #"+id+" filename:"+filename)

    return false if !File.exists?(filename)
    csv_text = parseIngestSpec(File.read(filename))
>>>>>>> b3dd59adf923e2cadcc235771d97df979002851a

    csv = CSV.parse(csv_text, :headers => true)
    #TODO validate csv.headers 
    # abort if this returns false
    # (currently does nothing)
    parseHeaders(csv.headers)
    
    #Create Row
    csv.each do |row,index|
      #This will store the persistent row object
      bmi_row = bmi_rows.find_by(text: row.to_s)
      
      if bmi_row.nil?
         # we have no row record for this yet
        bmi_row = bmi_rows.create(status: "unparsed",
                                  text: row.to_s,
                                  line_number: index + row_index_offset)
      else
        # we already have a row record
        #If the row is already parsed, move to the next row
        next if bmi_row.status == "parsed" || bmi_row.status == "ingested"
        #otherwise we proceed with the existing row record
      end

      #Create Cells
      #todo try/catch here
      #return newly parsed cells
      begin
        new_cells = bmi_row.createNewCells!(row) 
        rescue
          #do not raise an exception, just log it
          # in the future, save this associated w/row
          Rails.logger.warn "exception parsing row: "+bmi_row.id
          #raise
        else
          bmi_row.status = "parsed"
        ensure
          bmi_row.save
      end

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
    return 0 if !File.exists?(filename)
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
    # save header line for future re-parsing
  end

  def hasSpecLine? 
    return false if !File.exists(filename)
    csv_text = File.read(filename)
    spec = csv_text.lines.first
    return spec.downcase.include? "ingest name"
  end

  def parseIngestSpec(csv)
    spec = csv.lines.first
    if !spec.downcase.include? "ingest name"
      return csv
    end
    spec_elements = spec.split(",");
    spec_elements.each_with_index do |spec_key, index|
      next if index.odd?
      spec_value = spec_elements[index+1]

      case spec_key.downcase
          when "ingest name"
            write_attribute(:name,spec_value)
          when "work type"
            write_attribute(:work_type,spec_value)
          when "relationship identifier"
            write_attribute(:relationship_identifier,spec_value)
          when "edit identifier"
            write_attribute(:edit_identifier,spec_value)
          when "replace files"
            write_attribute(:replace_files, spec_value)
          when "visibility"
            write_attribute(:visibility, spec_value)
          when "notifications"
            write_attribute(:notifications, spec_value)
          when "ignore"
            write_attribute(:ignore, spec_value)
      end
      save
      return csv.lines[1..-1].join
    end

  end

  def ingest
    #for each correctly parsed row
    # call row.ingest!
  end

  def log!(type,subtype,message,row_id=null,cell_id=null)
    
  end
end

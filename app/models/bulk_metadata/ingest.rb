module BulkMetadata
  class Ingest < ApplicationRecord
    self.table_name = "bulk_meta_ingests"

    belongs_to :user
    has_many :rows
    attr_accessor :file

    #  enum status: [:unparsed, :checking, :check_passed, :check_failed, :processing, :completed, :completed_with_errors, :failed ]
    require 'csv'   

    def self.create_new(params)

      #    raise NameError, "What the hell is a subject.lc?!?", caller

      instance = self.new(params.except(:file));
      instance.status = "unparsed"
      # default to a work type called "Work"
      instance.work_type = "Work"
      instance.save
      instance.setFile(params[:file])
      if instance.name.starts_with? "batch_"
        instance.parse({editing: true})
      else
        instance.parse
      end
      instance
    end

    def get_csv(row_ids = "all")
      if row_ids == "all" || row_ids.nil? || row_ids.empty?
        csv_rows = rows
      else
        csv_rows = row_ids.map {|id| Row.find(id) }
      end
      csv_rows.reduce(headertext) {|csv,newrow| csv+newrow.text.gsub(/[\r\n]+/,"\r\n")}
    end

    def headers
      return @headers if !@headers.blank?
      return false if !File.exists(filename)
      csv_text = File.read(filename)
      csv = CSV.parse(csv_text, :headers => true)
      @headers = csv.headers
    end

    def headertext
      return false if !File.exists?(filename)
      headertext = File.read(filename).lines.first
      headertext += File.read(filename).lines.second if hasSpecLine?
      headertext
    end

    def parseChanged
      this.rows.where(status: "edited").each do |row|
        row.parse
      end
    end

    def parse(params={})
      editing = params.has_key? :editing && params[:editing]
      editIdentifier = "id" if editing

      return false if !File.exists?(filename)
      csv_text = File.read(filename)
      row_index_offset = 2
      if (hasSpecLine?)
        csv_text = parseSpecLine(csv_text)
        row_index_offset += 1
      end

      csv = CSV.parse(csv_text, headers: true)
      #TODO validate csv.headers 
      # abort if this returns false
      # (currently does nothing)
      parseHeaders(csv.headers)
      
      #Create Row
      csv.each_with_index do |row_text, index|
        #This will store the persistent row object
        row = rows.find_by(text: row_text.to_s)
        
        if row.nil?
          # we have no row record for this yet
          row = rows.create(status: "unparsed",
                            text: row_text.to_s,
                            line_number: index + row_index_offset)
        else
          # we already have a row record
          #If the row is already parsed, move to the next row
          next if row.status == "parsed" || row.status == "ingested"
          #otherwise we proceed with the existing row record
        end

        #Create Cells
        #todo try/catch here
        #return newly parsed cells
        begin
          new_cells = row.createNewCells!(row_text) 
        rescue => error
          #do not raise an exception, just log it
          # in the future, save this associated w/row
          row.status = "error"
          Rails.logger.error "Exception parsing row: "+row.id.to_s
          Rails.logger.error "Parsing exception "+error.inspect
        #          raise
        else
          row.status = "parsed"
        ensure
          row.save
        end

      end
    end

    def setFile(uploaded_file)
      #save csv file to permanent location
      save_as = File.join( Rails.root, 'public', 'uploads','batch_metadata_ingests',self.id.to_s + "_" + uploaded_file.original_filename)
      File.open( save_as.to_s, 'wb' ) do |file|
        file.write( uploaded_file.read) 
      end
      self.filename = save_as
    end

    def where_status(status)
      if status == "error"
        rows.where('status not like "parsed" and status not like "ingesting" and status not like "ingested" and status not like "unparsed"')
      else
        rows.where(status: status)
      end
    end

    def numUnparsed
      return rows.where(status:"unparsed").count unless rows.empty?
      return 0 if filename.blank? or !File.exists?(filename)
      csv_text = parseSpecLine(File.read(filename))
      csv_text.lines.count - 1;
    end

    def numParsed
      rows.where(status:"parsed").count
    end

    def numErrors
      rows.where('status not like "parsed" and status not like "ingesting" and status not like "ingested" and status not like "unparsed"').count
    end

    def numIngesting
      rows.where(status:"ingesting").count
    end

    def numIngested
      rows.where(status:"ingested").count
    end

    def parseHeaders(headers)
      specialHeaders = []
      headers.each do |header|
        return true unless specialHeaders.include?(header)
        return true unless work_type.constantize.new.send(header).nil?
        throw new Exception()
      end
      # each should correspond to a valid property
      # log any errors 
      # save header line for future re-parsing
    end

    def hasSpecLine? 
      return false if !File.exists?(filename)
      csv_text = File.read(filename)
      spec = csv_text.lines.first
      return spec.downcase.include? "ingest name"
    end

    def parseSpecLine(csv)
      spec = csv.lines.first
      if !spec.downcase.include? "ingest name"
        return csv
      end
      spec_elements = spec.split(",");
      spec_elements.each_with_index do |spec_key, index|
        next if index.odd?
        spec_value = spec_elements[index+1].strip

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
      rows.each do |row|
        next unless row.status == "parsed"
        row.ingest!
      end
      #for each correctly parsed row
      # call row.ingest!
    end

    def log!(type,subtype,message,row_id=null,cell_id=null)
      
    end
  end
end

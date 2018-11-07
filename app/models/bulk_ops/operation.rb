class BulkOps::Operation < ApplicationRecord
  belongs_to :user
  has_many :work_proxys
  self.table_name = "bulk_ops_operations"

  BASE_PATH = "/dams_ingest"
  TEMPLATE_DIR = "lib/bulk_ops/templates"
  RELATIONSHIP_COLUMNS = ["parent","child","next"]
  SPECIAL_COLUMNS = ["parent",
                     "child",
                     "order",
                     "next",
                     "work_type",
                     "collection", 
                     "collection_title",
                     "collection_id",
                     "visibility",
                     "relationship_identifier_type",
                     "id"]
  IGNORED_COLUMNS = ["ignore","offline_notes"]
  OPTION_REQUIREMENTS = {type: {required: true, 
                                values:[:ingest,:update]},
                         file_handling: {required: :update,
                                         values: []},
                         notifications: {required: true}}



  def error_message type, args, file=nil
    case type
    when :missing_required_option 
      error = "Error in your configuration file. Missing required option(s):"
      error += args.map{|arg| arg[:name]}.join(", ") + "\n"
    when :invalid_config_value 
      error = "Error(s) in your configuration file.\n" 
      args.each do |arg|
        error += "Unacceptable value for #{args[:name]}. Acceptable values include: #{args[:values]}\n"
      end
    when :cannot_get_headers 
      error = "Error verifying column headers: cannot retrieve headers from metadata spreadsheet on github. Either the connection to github or the metadata spreadsheet on this branch is problematic.\n"
    when :bad_header 
      error =  "Error - could not interpret column header(s): "
      error += args.map{|arg| arg[:name]}.join(", ")
    when :cannot_retrieve_label 
      error = ""
      args.each do |arg|
        error +=  "Error retrieving label for remote url #{arg.first[:url]}. This url appears in #{arg.count} instances in the spreadsheet, including the #{arg.first.column_name} column on row number #{arg.first.row} for example.\n"
      end
    when :bad_row_reference 
      error = "Error - bad object reference in row #{args.first[:row]}. Invalid row number reference: #{args.first[:id]}\n"
      if args.count > 1
        error += "#{args.count} other rows also had invalid row number references. We will not list them all here.\n"
      end
    when :cannot_find_file
      error = "Cannot find file #{args.first[:file]}."
      error += "The same problem occurred on #{args.count - 1} other rows. We won't list them all here." if args.count > 1
      
    when :bad_id_reference 
      error = "Error - bad object reference in row #{args.first[:row]}. Invalid Hydra ID reference: #{args.first[:id]}\n"
      error += "#{args.count - 1 } other rows also referred to nonexistent objects in the DAMS. We will not list them all here\n" if args.count > 1
    end
    file.write error if file && error
    return error
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA["work_types"][work_type.downcase]
  end

  def work_type
    options["work type"] || "work"
  end

  def verify
    error_file_name = "error_log_#{DateTime.now.strftime("%F-%H%M%p")}"
    errors = verify_configuration + verify_column_headers + verify_remote_urls + verify_internal_references + verify_files
    unless errors.blank?
      Tempfile.open(error_file_name) do |error_file|
        #write errors to error file
        errors.each { |type, typed_errors| error_file.write( error_message(type, typed_errors) ) } 

        #Add error file to github
        git.add_file error_file

        #notify everybody
        notify! "Errors verify spreadsheet for bulk #{operation_type}: #{name}", "Hyrax ran a verification step to make sure that the spreadsheet for this bulk #{operation_type} is formatted correctly and won't create any errors. We found some problems. You can see a summary of the issues at this url: https://github.org/UcscLibrary/#{git.repo}/#{git.name}/#{error_file_name}?branch=#{git.name}. Please fix these problems and run this verification again. The bulk #{operation_type} will not be allowed to move forward until all verification issues are resolved, to protect the integrity of the data in the system."
      end
      return false
    end
    return true
  end

  def notify! subject:, message:
    options["notifications"].each do |email|
      mail(from: "admin@digitalcollections.library.ucsc.edu",
           to: email,
           subject: subject,
           body: message)
    end
  end

  def verify_files 
    errors = {"cannot_find_file":[]}
    metadata.each do |row, row_num|
      next unless (file_string = row["file"]) || (file_string = row["filename"])
      filenames = file_string.split(';')
      filenames.each do |filename|
        errors << {file: filename} unless File.file? File.join(BASE_PATH,filename)
      end
    end
    return errors
  end

  def verify_configuration
    errors = {"missing_required_option":[],
             "invalid_config_value":[],
             }
    OPTION_REQUIREMENTS.each do |option_name, option_info|

      # Make sure it's present if required
      if (option_info["required"].to_s == "true") || (option_info["required"].to_s == type)

        if options[option_name].blank?
          errors["missing_required_option"] << {name: option_name}
        end
      end

      # Make sure the values are acceptable if present
      unless (values = option_info.values).blank? || option[option_name].blank?
        unless values.include? option[option_name]
          values_string = values.reduce{|a,b| "#{a}, #{b}"}
          errors["invalid_config_value"] << {name: option_name, values: values_string}
        end        
      end
    end    
    return errors
  end

  # Make sure the headers in the spreadsheet are matching to properties
  def verify_column_headers
    error = {"cannot_get_headers":[],
            "bad_header":[]}
    unless (headers = metadata.get_headers)
      # log an error if we can't get the metadata headers
      errors["cannot_get_headers"] << true
    end

    headers.each do |column_name|
      column_name = column_name.parameterize.underscore

      # Ignore everything marked as a label
      next if column_name.ends_with "_label"
      
      # Ignore any column names with special meaning in hyrax
      next if SPECIAL_COLUMNS.include? column_name

      # Ignore any columns speficied to be ignored in the configuration
      next if options["ignored headers"] && options["ignored headers"].include?(column_name)
      
      # Column names corresponding to work attributes are legit
      next if Work.attribute_names.include? column_name
      errors["bad_header"] << {name: column_name}
    end
    return errors
  end

  def verify_remote_urls
    errors = {"cannot_retrieve_label":[]}
    metadata.each do |row, row_num|
      schema["controlled"].each do |controlled_field|
        next unless (url = row[controlled_field])
        label = ::WorkIndexer.fetch_remote_label(url)        
        if !label || label.blank?
          errors["cannot_retrieve_label"] << {row: row_num + ROW_OFFSET, 
                                              field: controlled_field,
                                              url: url}
        end
      end
    end
    return errors
  end

  def verify_internal_references
    errors = {"bad_object_reference":[]}
    metadata.each do |row,row_num|
      ref_id = row['reference_identifier'] || reference_identifier
      RELATIONSHIP_COLUMNS.each do |relationship|
        next unless (obj_id = row[relationship])
        if (split = obj_id.split(':')).count == 2
          ref_id = split[0].downcase
          obj_id = split[1]
        end
        
        if ref_id == "row" || (ref_id == "id/row" && obj_id.is_a?(Integer))
          # This is a row number reference. It should be an integer in the range of possible row numbers.
          unless obj_id.is_a? Integer && obj_id > 0 && obj_id <= metadata.count
            errors[:bad_row_reference] << {id: obj_id, row: row_num + ROW_OFFSET}
          end  
        elsif ref_id == "id" || ref_id == "hyrax id" || (ref_id == "id/row" && (obj_id.is_a? Integer))
          # This is a hydra id reference. It should correspond to an object already in the repo
          unless SolrDocument.find(obj_id) || ActiveFedora::Base.find(obj_id)
            errors[:bad_id_reference] << {id: obj_id, row: row_num+ROW_OFFSET}
          end
        else
          # This must be based on some other presumably unique field in hyrax. We haven't added this functionality yet. Ignore for now.
        end
      end      
    end
    return errors
  end


  def reference_identifier
    options["reference_identifier"] || "id/row"
  end


  def apply!
    status = "#{type}ing"
    stage = "running"
    message = "#{type.titleize} initiated by #{user.name || user.email}"
    save
    
    get_final_spreadsheet
    
    return unless verify

    apply_ingest! if ingest?
    apply_update! if update?
  end

  def apply_ingest! spreadsheet
    #destroy any existing work proxies, which should not exist for an ingest. Create new proxies from finalized spreadsheet only.
    work_proxys.each{|proxy| proxy.destroy!}

    #create a work proxy for each row in the spreadsheet
    @metadata.each_with_index do |values,row_number|
      proxy = work_proxies.create(status: "queued",
                                  last_event: DateTime.now,
                                  row_number: row_number,
                                  message: "Placeholder during ingest initiated by #{user.name || user.email}")
    end

    #loop through the work proxies to create a job for each work
    work_proxies.each do |proxy|
      data = proxy.interpret_data spreadsheet[proxy.row_number]
      unless proxy.errors.blank?
        
      end
      BulkOps.IngestJob.perform_later(proxy.work_type || "Work",user.email,data,proxy.id,proxy.visibility || "open")
    end
  end

  def apply_update! spreadsheet
    @metadata.each_with_index do |values,row_number|
      proxy = BulkOps::WorkProxy.find_by(operation_id: id, work_id: values["work_id"])
      #todo throw & log appropriate exeption if work_id column not found or work referred to not found
      
      proxy.status = "updating"
      proxy.message = "update initiated by #{user.name || user.email}"
      proxy.save
    end

    #loop through the work proxies to create a job for each work
    work_proxies.each do |proxy|
      data = proxy.interpret_data spreadsheet[proxy.row_number]
      BulkOps.UpdateJob.perform_later(proxy.id,data,user.email,proxy.visibility || "open")
    end
  end

  def create_branch(fields: nil, work_ids: nil, options: nil)
    work_ids ||= work_proxys.map{|proxy| proxy.work_id}
    fields ||= default_metadata_fields

    git.create_branch!

    #copy template files
    Dir["#{Rails.root}/#{TEMPLATE_DIR}/*"].each{|file| git.add_file file}

    #update configuration options 
    unless options.blank?
      new_options = YAML.load_file(File.join(Rails.root,TEMPLATE_DIR, BulkOps::GithubAccess::OPTIONS_FILENAME))
      options.each { |option, value| new_options[option] = value }
      git.update_options new_options
    end
    
    #add metadata spreadsheet
    @metadata = self.class.works_to_csv(work_ids, fields)
    git.add_new_spreadsheet @metadata

  end

  def self.works_to_csv work_ids, fields
    work_ids.reduce(fields.join(',')){|csv, work_id| csv + "\r\n" + self.work_to_csv(work_id,fields)}  end

  def get_spreadsheet
    @metadata ||= git.load_metadata
  end

  def get_final_spreadsheet
    @metadata ||= git.load_metadata "master"
  end

  def update_spreadsheet filename, message=false
    git.update_spreadsheet(filename, message)
  end

  def update_options filename, message=false
    git.update_options(filename, message)
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
    git.delete_branch!
    super
  end

  def delete_branch
    git.delete_branch!
  end

  def destroy
    git.delete_branch!
    super
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
    options['ignored headers'] + IGNORED_COLUMNS
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
      values = work.send(field_name)
      values.map do |value|
        value = (label ? WorkIndexer.fetch_remote_label(value.id) : value.id) unless value.is_a? String
        value.gsub("\"","\"\"")
      end.join(';')
    end.join(',')
  end

  def self.filter_fields fields, label = true
    fields.each do |field_name, field|
      # reject if not in scoobysnacks
      # add label if needed
    end
  end
  
end



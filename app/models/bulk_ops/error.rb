class BulkOps::Error
  attr_accessor :type, :row_number, :object_id, :message, :option_name, :file, :option_values, :field, :url

  MAX_ERROR = 50

  def initialize type:, row_number: nil, object_id: nil, message: nil, options_name: nil, option_values: nil, field: nil, url: nil , file: nil
    @type = type
    @row_number = row_number
    @object_id = object_id
    @message = message
    @option_name = option_name
    @option_values = option_values
    @field = field
    @file = file
    @url = url
  end

  def self.write_errors! errors, git
    return false if errors.blank?
    error_file_name = "error_log_#{DateTime.now.strftime("%F-%H%M%p")}.log"

    error_hash = {}

    errors.sort!{|x,y| x.type <=> y.type}
    error_types = errors.map{|error| error.type}.uniq

    #write errors to error file
    error_file = Tempfile.new(error_file_name)
    error_types.each do |error_type|
      typed_errors = errors.select{|er| er.type == error_type}
      next if typed_errors.blank?
      message = self.error_message(error_type, typed_errors)
      puts "Error message: #{message}"
      error_file.write(message)
    end
    error_file.close
    git.add_file error_file.path, File.join("errors", error_file_name)
    error_file.unlink
    return error_file_name
  end

  def self.error_message type, errors
    case type
    when :missing_required_option 
      message = "\n-- Errors in configuration file -- \nMissing required option(s):"
      message += errors.map{|arg| error.option_name}.join(", ") + "\n"

    when :invalid_config_value 
      message = "\n-- Errors in configuration file values --\n" 
      errors.each do |error|
        message += "Unacceptable value for #{error.option_name}. Acceptable values include: #{error.option_values}\n"
      end

    when :cannot_get_headers 
      message += "\n-- Error Retrieving Field Headers --\n"
      message += "We cannot retrieve the column headers from metadata spreadsheet on github,\nwhich define the fields for the metadata below.\nEither the connection to github is failing, \nor the metadata spreadsheet on this branch is not properly formatted.\n"

    when :bad_header 
      message =  "\n-- Error interpreting column header(s) --\n"
      message += "We cannot interpret all of the headers from your metadata spreadsheet. \nSpecifically, the following headers did not make sense to us:\n"
      message += errors.map{|error| error.field}.join(", ")+"\n"

    when :cannot_retrieve_label 
      message = "\n-- Errors Retrieving Remote Labels --\n"
      urls = errors.map{|error| error.url}.uniq
      if urls.count < MAX_ERROR
        urls.each do |url|
          url_errors = errors.select{|er| er.url == url}
          message +=  "Error retrieving label for remote url #{url}. \nThis url appears in #{url_errors.count} instances in the spreadsheet.\n The rows are listed here:\n"
          message += url_errors.map{|er| er.row_number}.join(',')+"\n"
        end
      else
        message += "There were #{urls.count} different URLs in the spreadsheet that we couldn't retrieve labels for,\n making a total of #{errors.count} url related errors.\n These are too many to list, but an example is #{errors.first.url}\n in row #{errors.first.row_number}.\n"
      end

    when :bad_object_reference 
      message = "\n-- Error: bad object reference --\m" 
      message += "We enountered #{errors.count} problems resolving object references.\n"
      if errors.count < MAX_ERROR
         message += "The row numbers with problems were:\n"
         message += errors.map{|er| "row number #{er.row_number} references the object #{er.object_id}"}.join("\n")
      else
         message += "For example, row number #{errors.first.row_number} references an object identified by #{errors.first.object_id}, which we cannot find."
      end
              
    when :cannot_find_file
      message = "\n-- Missing File Errors --\n "
      message += "We couldn't find the files listed on #{errors.count} rows.\n"
      if errors.count < MAX_ERROR
        message += "Missing filenames:\n"
        message += errors.map{|er| er.file}.join("\n")
      else
        message += "An example of a missing filename is: #{errors.first.file}\n"
      end
      
    end
    return message
  end
end

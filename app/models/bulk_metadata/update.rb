class BulkMetadata::Update

  attr_accessor :branch_name, :name, :status, :errors, :type, :user, :notifications, :default_work_type, :metadata_csv, :rows

  def self.load branch_name_to_load
    edit = self.new(branch_name: branch_name_to_load)
    edit.reload
  end

  def self.list
    GithubAccesss.list_branches.map{|branch| branch[:name]}
  end

  def reload
    load_configuration
    load_rows
    load_status
  end
  
  def load_configuration
    config =  YAML.load(GithubAccess.get_file_contents branch_name 'configuration.yml')
    name = config[:name]
    type = config[:type]
    user = config[:user]
    notifications = config[:notifications]
    default_work_type = config[:default_work_type]
  end

  def load_status
    status =  GithubAccess.get_file_contents branch_name 'status.yml'
    errors = GithubAccess.get_file_contents branch_name 'errors.yml'
    errors.each do |error|
      message = error[:message] || "An error occurred ingesting row #{error[:row_number]}"
      if error[:row_number]
        row = rows.select{ |row| row.row_number == error[:row_number]}.first
        
      end
    end
  end

  def load_rows
    metadata_csv  = GithubAccess.get_file_contents branch_name 'metadata.csv'
    rows = [false]
    CSV.parse(metadata_csv, headers: true).each_with_index do |new_row_hash, rownum|      
      rows[row_num + 1] = Row.new { metadata: new_row_hash,
                                    update_id: id,
                                    status: "unknown" }
    end
    @rows = rows
  end

  def parse_csv csv=nil
    csv ||= metadata_csv
  end

  def create name, work_ids = [], options={}, branch_name:
    branch_name ||= name
    branch_name = branch_name.parameterize

    begin
      GithubAccess.create_branch branch_name
      
      # copy template files (Readme and default configs)
      Dir["#{Rails.root}/lib/bulk_metadata/templates/*"].each do |template_file_path| 
        GithubAccess.add_file branch_name template_file_path 
      end
      
      # Create metadata spreadsheet
      metadata = Work.to_csv(work_ids, true)
      GithubAccess.add_contents branch_name, 'metadata.csv', metadata, branch: branch_name

    rescue
      false
    end

  end
  
#  def collapse_multivalue values
#    values.kind_of?(Array) ? values.join(';') : values
#  end
#
end

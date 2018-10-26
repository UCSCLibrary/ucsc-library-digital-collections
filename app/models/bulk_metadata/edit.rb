class BulkMetadata::Edit 

  attr_accessor :branch_name, :name, :status, :errors, :type, :user, :notifications, :default_work_type, :metadata_csv, :rows

  def self.load branch_name
    edit = self.new(branch_name: branch_name)
    edit.reload
  end

  def self.list
    GithubAccesss.list_branches.map{|branch| branch[:name]}
  end

  def self.all
     GithubAccesss.list_branches.map{|branch| self.new name: branch[:name], sha: branch[:commit][:sha] }
  end

  def reload
    
    
  end

  def github_files
    @github_files ||= GithubAccess.fetch
  end

  def fetch_github_files
    @github_files ||= fetch_github_files
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

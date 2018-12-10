class BulkOps::Operation < ApplicationRecord
  self.table_name = "bulk_ops_operations"
  belongs_to :user
  has_many :work_proxies, class_name: "BulkOps::WorkProxy"

  include BulkOps::Verification

  attr_accessor :work_type, :visibility, :reference_identifier
  
  delegate  :can_merge?, :merge_pull_request, to: :git

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
                     "id",
                     "filename",
                     "file"]
  IGNORED_COLUMNS = ["ignore","offline_notes"]
  OPTION_REQUIREMENTS = {type: {required: true, 
                                values:[:ingest,:update]},
                         file_handling: {required: :update,
                                         values: []},
                         notifications: {required: true}}


  def proxy_errors
    work_proxies.reduce([]){|errors, proxy| errors + (proxy.proxy_errors || [])} 
  end

  def proxy_states
    states = {}
    work_proxies.each{|proxy| (states[proxy.status] ||= []) << proxy }
    states
  end

  def type
    operation_type
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA["work_types"][work_type.downcase]
  end

  def work_type
    options["work type"] || "work"
  end
  
  def reference_identifier
    options["reference_identifier"] || "id/row"
  end
  
  def set_stage new_stage
    self.stage = new_stage
    save
  end

  def apply!
    status = "#{type}ing"
    stage = "running"
    message = "#{type.titleize} initiated by #{user.name || user.email}"
    save
    
    get_final_spreadsheet
    
    return unless verify!

    apply_ingest! if ingest?
    apply_update! if update?
  end

  def apply_ingest! 
    #destroy any existing work proxies, which should not exist for an ingest. Create new proxies from finalized spreadsheet only.
    work_proxies.each{|proxy| puts "destroying proxy ##{proxy.id}";proxy.destroy!}

    #create a work proxy for each row in the spreadsheet
    (spreadsheet = get_spreadsheet).each_with_index do |values,row_number|
      next if values.to_s.gsub(',','').blank?
      work_proxies.create(status: "queued",
                          last_event: DateTime.now,
                          row_number: row_number,
                          message: "created during ingest initiated by #{user.name || user.email}")
    end

    reload
    #loop through the work proxies to create a job for each work
    work_proxies.each do |proxy|
      proxy.message = "interpreted at #{DateTime.now.strftime("%d/%m/%Y %H:%M")} " + proxy.message
      proxy.save

      data = proxy.interpret_data spreadsheet[proxy.row_number] 
      
      next unless proxy.proxy_errors.blank?
      
      BulkOps::CreateWorkJob.perform_later(proxy.work_type || "Work",
                                           user.email,
                                           data,
                                           proxy.id,
                                           proxy.visibility || "open")
    end
  end

  def apply_update! spreadsheet
    get_spreadsheet.each_with_index do |values,row_number|
      proxy = BulkOps::WorkProxy.find_by(operation_id: id, work_id: values["work_id"])
      #todo throw & log appropriate exeption if work_id column not found or work referred to not found
      
      proxy.status = "updating"
      proxy.message = "update initiated by #{user.name || user.email}"
      proxy.save
    end

    #loop through the work proxies to create a job for each work
    work_proxies.each do |proxy|
      data = proxy.interpret_data spreadsheet[proxy.row_number]
      BulkOps.UpdateWorkJob.perform_later(proxy.id,data,user.email,proxy.visibility || "open")
    end
  end

  def create_pull_request
    return false unless (pull_num = git.create_pull_request)
    self.pull_id = pull_num
    self.save
    return pull_num
  end

  def create_branch(fields: nil, work_ids: nil, options: nil)
    work_ids ||= work_proxies.map{|proxy| proxy.work_id}
    fields ||= self.default_metadata_fields

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

  def get_spreadsheet return_headers: false
    git.load_metadata return_headers: return_headers
  end

  def get_final_spreadsheet
    @metadata ||= git.load_metadata branch: "master"
  end

  def update_spreadsheet file, message=false
    git.update_spreadsheet(file, message)
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

  def complete?
    return (stage == 'complete')
  end

  def busy?
    prxs = proxy_states
    return true unless prxs["running"].blank? || prxs[""].blank?
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

  def self.default_metadata_fields labels = true
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
    (options['ignored headers'] || []) + IGNORED_COLUMNS
  end


  def error_url
    "https://github.com/#{git.repo}/tree/#{git.name}/#{git.name}/errors"
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



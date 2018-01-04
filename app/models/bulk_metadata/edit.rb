class BulkMetadata::Edit < ApplicationRecord
  self.table_name = "bulk_meta_edits"
  
  def self.create_new(params,user)
    instance = self.new(params.except(:ids));
    instance.setWorkIds(ids)
    instance.status = "new"
    instance.user = is_object(user) ? user.email : user
    instance.save
    instance
  end

  def setWorkIds(work_ids)
    @work_ids = Marshal.dump(work_ids)
  end

  def getWorkIds
    Marshal.load(work_ids)
  end


  def export_csv(user, ids = nil, advance_workflow = true)
    require 'csv'
    ids = work_ids if ids.nil? or ids.empty?    

    ids.each { |id| advance_workflow(user,id)} if advance_workflow

    metadata = ids.map {|id| get_metadata(SolrDocument.find(id))}
    meta_keys = consolidate_metadata_keys(metadata)

    csv = CSV.generate do |csv|
      csv << get_file_header_line
      csv << meta_keys
      metadata.each do |work_meta|
        line = []
        meta_keys.each do |key|
          if defined? work_meta[key] and !work_meta[key].nil?
            line << collapse_multivalue(work_meta[key])
          else
            line << ""
          end
        end
        csv << line
      end
    end

  end

  def advance_workflow(user,id,action="edit_offline")
    work = Work.find(id)
    subject = Hyrax::Workflow::WorkflowActionInfo.new(work,user)
    sipity_workflow_action = PowerConverter.convert_to_sipity_action(action, scope: subject.entity.workflow) { nil }
    
    Hyrax::Workflow::WorkflowActionService.run(subject: subject,
                                        action: sipity_workflow_action,
                                        comment: comment)
  end

  def get_file_header_line
    header = []
    header << "ingest_name"
    header << "batch_#{user}_"+id.to_s
    header << "relationship_identifier"
    header << "id"
    header << "notifications"
    header << "yes"
    header
  end

  private

  def get_metadata(work)
    work.keys.reduce({"id" => work.id}) do |metadata, key|
      if key.include? "_tesim"
        subkey = key.sub("_tesim","")
        metadata[subkey] = work.send(subkey)
      end
      metadata
    end
  end

  def get_metadata_keys(work) 
    work.keys.reduce(["id"]) do |mkeys, key|
      mkeys << key.sub("_tesim","") if key.include? "_tesim"
    end
  end

  def consolidate_metadata_keys (metadata)
    metadata.reduce([]) do |headers, item_meta|
      headers | item_meta.keys
    end
  end

  def collapse_multivalue values
    values.kind_of?(Array) ? values.join(';') : values
  end

end

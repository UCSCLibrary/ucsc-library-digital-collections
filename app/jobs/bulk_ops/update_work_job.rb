require 'hydra/access_controls'
require 'hyrax/workflow/activate_object'

class BulkOps::UpdateWorkJob < ActiveJob::Base
  attr_accessor :status, :proxy, :work

  queue_as :ingest

  after_perform do |job|
    
    # update BulkOperationsWorkProxy status
    if  @work.id.nil? && (@work = Work.find(@proxy.work_id)).nil?
      @proxy.status = "error"
    else
      @proxy.work_id = @work.id
      @proxy.status = "complete"
    end
    @proxy.save    

    # Attempt to resolve all of the relationships defined in this row    
    @proxy.relationships.each do |relationship|
      relationship.resolve!
    end
    # Attempt to resolve each dangling (objectless) relationships using   
    # this work as an object
    BulkMetadata::Relationship.where(:status => "objectless").each do |relationship|
      relationship.resolve! @work.id
    end

    # Delete any UploadedFiles. These take up tons of unnecessary disk space.
    @work.file_sets.each do |fileset|
      if uf = Hyrax::UploadedFile.find_by(file: fileset.label)
        uf.destroy!
      end
    end
  end

  def perform(work_proxy_id,attributes,user_email,visibility="private")
    @work_proxy = BulkOperationsWorkProxy.find(work_proxy_id) if work_proxy_id
    @status = "updating work now"
    update_status
    #TODO ACTUALLY PERFORM THE UPDATE
  end

  private

  def update_status message=false
    return false unless @work_proxy
    @work_proxy.status = @status
    @work_proxy.message = message if message
    @work_proxy.save
  end 

end

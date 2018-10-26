require 'hydra/access_controls'
require 'hyrax/workflow/activate_object'

class BulkOperationsJob < ActiveJob::Base
  attr_accessor :status, :row, :work

  queue_as :ingest

  after_perform do |job|
    
    # update BulkOperationsWorkProxy status
    if  @work.id.nil?
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

  def perform(workClass,user_email,attributes,work_proxy_id=nil,visibility="private")
    @work_proxy = BulkOperationsWorkProxy.find(work_proxy_id) if work_proxy_id
    @status = "performing now"
    update_status 
    @row = BulkMetadata::Row.find(row_id)
    @work = workClass.constantize.new
    user = User.find_by_email(user_email)
    ability = Ability.new(user)
    env = Hyrax::Actors::Environment.new(@work, ability, attributes)
    @status = Hyrax::CurationConcern.actor.create env 
    update_status
  end

  private

  def update_status
    return false unless @work_proxy
    @work_proxy.status = @status
    @work_proxy.save
  end 

end

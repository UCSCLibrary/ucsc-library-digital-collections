class UcscEditWorkJob < ActiveJob::Base
  queue_as :ingest

  after_perform do |job|
    row = BulkMetadata::Row.find(job.arguments[3])
    break if row.nil?
    row.status = "ingested"
    row.save
 
    # attempt to resolve all of the relationships defined in this row    
    row.relationships.each do |relationship|
      relationship.resolve!
    end
    # attempt to resolve each dangling (objectless) relationship using
    
    # this row as a potential object
    BulkMetadata::Relationship.where(:status => "objectless").each do |relationship|
      relationship.resolve! row.id
    end

  end

  def perform(workClass,user,attributes,row_id=nil,visibility=nil)
    

#    work = workClass.constantize.new
#    actor = Hyrax::CurationConcern.actor(work,user)
#    status = actor.create(attributes)
    
    #TODO log success or failure
    # status is true or false
    # if false, error messages are:
    # work.errors.full_messages.join(' '))
  end

  #todo on complete update status of parent
end

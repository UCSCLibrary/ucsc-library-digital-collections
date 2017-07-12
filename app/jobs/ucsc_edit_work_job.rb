class UcscEditWorkJob < ActiveJob::Base
  queue_as :ingest

  after_perform do |job|
    row_id = BmiRow.find(job.arguments[3])
    break if row_id.nil?
    row = BmiRow.find(row_id)
    row.status = "ingested"
    row.save

    # attempt to resolve all of the relationships defined in this row
    row.bmi_relationships.each do |relationship|
      relationship.resolve!
    end

    # attempt to resolve each dangling (objectless) relationship using
    # this row as a potential object
    BmiRelationship.where(:status => "objectless").each do |relationship|
      relationship.resolve! row.id
    end

  end

  def perform(workClass,user,attributes,bmi_row_id=nil)
    # Get this to work in an initializer somewhere, right?
    #Hyrax::CurationConcern.actor_factory = Ucsc::ActorFactory

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

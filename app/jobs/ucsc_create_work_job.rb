require 'hydra/access_controls'
require 'hyrax/workflow/activate_object'

#class UcscCreateWorkJob < Hyrax::ApplicationJob
class UcscCreateWorkJob < ActiveJob::Base
  queue_as :ingest

  after_perform do |job|
    row = BulkMetadata::Row.find(job.arguments[3])
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

  def perform(workClass,user_email,attributes,row_id=nil,visibility="private")
    
    #hack for now, default admin set doesn't work
    # TODO make this a required ingest option 
    # with optional override
    # AND fix default admin set workflow

    work = workClass.constantize.new
    user = User.find_by_email(user_email)
    ability = Ability.new(user)
    env = Hyrax::Actors::Environment.new(work, ability, attributes)
    status = Hyrax::CurationConcern.actor.create env 

    if( status != "error") #change this to an actual error check
      row = BulkMetadata::Row.find(row_id)
      unless row.nil?
        row.set_work_id(work.id)
        row.status = "ingested"
        row.save
      end
    end
    
    #TODO log success or failure
    # status is true or false
    # if false, error messages are:
    # work.errors.full_messages.join(' '))

    #todo on complete update status of parent
  end


end

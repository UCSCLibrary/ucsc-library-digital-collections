class UcscCreateWorkJob < ActiveJob::Base
  queue_as :ingest

  def perform(workClass,user,attributes)
    # Get this to work in an initializer somewhere, right?
    #CurationConcerns::CurationConcern.actor_factory = Ucsc::ActorFactory

    work = workClass.constantize.new
    actor = CurationConcerns::CurationConcern.actor(work,user)
    status = actor.create(attributes)
    

    #TODO log success or failure
    # status is true or false
    # if false, error messages are:
    # work.errors.full_messages.join(' '))
  end
end

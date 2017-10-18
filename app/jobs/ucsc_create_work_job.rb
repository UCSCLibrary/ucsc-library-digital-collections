#class UcscCreateWorkJob < Hyrax::ApplicationJob
class UcscCreateWorkJob < ActiveJob::Base
  queue_as :ingest

  after_perform do |job|
    row_id = BmiRow.find(job.arguments[3])
    break if row_id.nil?
    row = BmiRow.find(row_id)
    row.status = "ingested"
    row.save
  end

  def perform(workClass,user_email,attributes,bmi_row_id=nil,visibility="private")
    
    # CURRENT ISSUES:
    #  - metadata seems to come back with files in it,
    #      screwing things up
    #  - there is an admin set / workflow problem here
    #      it looks for and fails to find default one

    #hack for now, default admin set doesn't work
    # TODO make this a required ingest option 
    # with optional override
    # AND fix default admin set workflow
    attributes[:admin_set_id] = AdminSet.all.second.id
    work = workClass.constantize.new
    user = User.find_by_email(user_email)
    ability = Ability.new(user)
    actor = Hyrax::ActorFactory.build(work,ability)    
    status = actor.create(attributes)

#    current_ability = Ability.new(User.find_by_email(user))
#    env = Hyrax::Actors::Environment.new(work, current_ability, attributes)
#    status = work_actor.create(env)
    
    #TODO log success or failure
    # status is true or false
    # if false, error messages are:
    # work.errors.full_messages.join(' '))

    #todo on complete update status of parent
  end


  private

  def work_actor
    Hyrax::CurationConcern.actor
  end
end

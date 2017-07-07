class UcscCreateWorkJob < ActiveJob::Base
  queue_as :ingest

  after_perform do |job|
    row_id = BmiRow.find(job.arguments[3])
    break if row_id.nil?
    row = BmiRow.find(row_id)
    row.status = "ingested"
    row.save
  end

  def perform(workClass,user,attributes,bmi_row_id=nil)

    work = workClass.constantize.new
    actor = Hyrax::CurationConcern.actor(work,user)
    status = actor.create(attributes)
    
    #TODO log success or failure
    # status is true or false
    # if false, error messages are:
    # work.errors.full_messages.join(' '))
  end

  #todo on complete update status of parent
end

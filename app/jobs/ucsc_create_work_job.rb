require 'hydra/access_controls'
require 'hyrax/workflow/activate_object'

#class UcscCreateWorkJob < Hyrax::ApplicationJob
class UcscCreateWorkJob < ActiveJob::Base
  attr_accessor :status, :row, :work

  queue_as :ingest

  after_perform do |job|
    
    # Adjust BulkMetadata Row status
    if @status.to_s.downcase.include? "error"
      @row.status = "ingest error"
    elsif @work.id.nil?
      @row.status = "error"
    else
      @row.ingested_id = @work.id
      @row.status = "ingested"
    end
    @row.save    

    # Attempt to resolve all of the relationships defined in this row    
    @row.relationships.each do |relationship|
      relationship.resolve!
    end
    # Attempt to resolve each dangling (objectless) relationships using   
    # this row as an object
    BulkMetadata::Relationship.where(:status => "objectless").each do |relationship|
      relationship.resolve! @row.id
    end

    # Delete any UploadedFiles
    @work.file_sets.each do |fileset|
      if uf = Hyrax::UploadedFile.find_by(file: fileset.label)
        uf.destroy!
      end
    end
  end

  def perform(workClass,user_email,attributes,row_id=nil,visibility="private")
    @status = "performing now"
    @row = BulkMetadata::Row.find(row_id)
    @work = workClass.constantize.new
    user = User.find_by_email(user_email)
    ability = Ability.new(user)
    env = Hyrax::Actors::Environment.new(@work, ability, attributes)
    @status = Hyrax::CurationConcern.actor.create env 
  end

end

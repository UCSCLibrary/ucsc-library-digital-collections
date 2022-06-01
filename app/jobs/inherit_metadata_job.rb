# frozen_string_literal: true

class InheritMetadataJob < Hyrax::ApplicationJob
  def perform(work_id:)
    # call Work#save to trigger Work#inherit_metadata
    Work.find(work_id).save
  end
end

# frozen_string_literal: true

require_dependency Bulkrax::Engine.root.join('app', 'jobs', 'bulkrax', 'create_relationships_job').to_s

# OVERRIDE FILE from Bulkrax v3.2.0
module Bulkrax
  CreateRelationshipsJob.class_eval do
    # OVERRIDE: trigger job to inherit metadata after relationships are created
    def perform(parent_identifier:, importer_run_id:) # rubocop:disable Metrics/AbcSize
      pending_relationships = Bulkrax::PendingRelationship.find_each.select do |rel|
        rel.bulkrax_importer_run_id == importer_run_id && rel.parent_id == parent_identifier
      end.sort_by(&:order)

      @importer_run_id = importer_run_id
      @parent_entry, @parent_record = find_record(parent_identifier, importer_run_id)
      @child_records = { works: [], collections: [] }
      pending_relationships.each do |rel|
        raise ::StandardError, %("#{rel}" needs either a child or a parent to create a relationship) if rel.child_id.nil? || rel.parent_id.nil?
        @child_entry, child_record = find_record(rel.child_id, importer_run_id)
        child_record.is_a?(::Collection) ? @child_records[:collections] << child_record : @child_records[:works] << child_record
      end

      if (child_records[:collections].blank? && child_records[:works].blank?) || parent_record.blank?
        reschedule({ parent_identifier: parent_identifier, importer_run_id: importer_run_id })
        return false # stop current job from continuing to run after rescheduling
      end
      @parent_entry ||= Bulkrax::Entry.where(identifier: parent_identifier,
                                             importerexporter_id: ImporterRun.find(importer_run_id).importer_id,
                                             importerexporter_type: "Bulkrax::Importer").first
      create_relationships
      pending_relationships.each(&:destroy)

      # OVERRIDE: trigger job to inherit metadata after relationships are created
      child_records[:works]&.each do |work|
        ::InheritMetadataJob.perform_later(work_id: work.id)
      end
    rescue ::StandardError => e
      parent_entry ? parent_entry.status_info(e) : child_entry.status_info(e)
      Bulkrax::ImporterRun.find(importer_run_id).increment!(:failed_relationships) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end

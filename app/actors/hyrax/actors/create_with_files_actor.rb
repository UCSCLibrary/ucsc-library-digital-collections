# frozen_string_literal: true

require_dependency Hyrax::Engine.root.join('app', 'actors', 'hyrax', 'actors', 'create_with_files_actor').to_s

# OVERRIDE FILE from Hyrax 2.9.6
Hyrax::Actors::CreateWithFilesActor.class_eval do
  private

  # OVERRIDE: filter out params that are incompatible with ActiveJob
  def attach_files(files, env)
    return true if files.blank?

    AttachFilesToWorkJob.perform_later(
      env.curation_concern,
      files,
      # Filter out attributes that cause the following error:
      # ActiveJob::SerializationError - Only string and symbol hash keys may be serialized as job arguments, but 0 is a Integer
      # Example param: :subjectName_attributes=>{"0"=>{"id"=>"info:lc/authorities/names/n85279544"}
      env.attributes.to_h.symbolize_keys.except(*controlled_field_attribute_names)
    )
    true
  end

  def controlled_field_attribute_names
    attribute_names = []

    ScoobySnacks::METADATA_SCHEMA.controlled_field_names.each { |el| attribute_names << "#{el}_attributes".to_sym }

    attribute_names
  end
end

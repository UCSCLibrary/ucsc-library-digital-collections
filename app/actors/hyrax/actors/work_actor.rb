# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  module Actors
    class WorkActor < Hyrax::Actors::BaseActor
      private

      # OVERRIDE: Null out each controlled field before saving, meaning only
      # incoming values will persist on the record. This results in blank
      # controlled values in ingested CSVs being "deleted".
      def apply_save_data_to_curation_concern(env)
        null_controlled_fields!(env)

        super
      end

      # OVERRIDE: Add custom method to make Bulkrax and ScoobySnacks more compatible
      def null_controlled_fields!(env)
        clean_attrs = clean_attributes(env.attributes)
        ::ScoobySnacks::METADATA_SCHEMA.controlled_field_names.each do |field_name|
          # do not null fields that are not being changed
          next unless clean_attrs.keys.include?("#{field_name}_attributes")

          env.curation_concern.public_send("#{field_name}=", [])
        end
      end
    end
  end
end

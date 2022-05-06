# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  module Actors
    class WorkActor < Hyrax::Actors::BaseActor
      private

      def apply_save_data_to_curation_concern(env)
        # OVERRIDE: Null out each controlled field before saving, meaning only
        # incoming values will persist on the record. This results in blank
        # controlled values in ingested CSVs being "deleted".
        ::ScoobySnacks::METADATA_SCHEMA.controlled_field_names.each do |field_name|
          env.curation_concern.public_send("#{field_name}=", [])
        end

        super
      end
    end
  end
end

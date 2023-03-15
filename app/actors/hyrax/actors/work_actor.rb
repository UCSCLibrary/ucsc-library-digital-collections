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

          # Remove empty strings from curation_concern RDF arrays, we shouldn't have to do this...
          no_empties = env.curation_concern["#{field_name}"].reject {|f| f.is_a?(String) && f.blank?}
          env.curation_concern.public_send("#{field_name}=", no_empties)

          # do not null fields if the _destroy property is set
          null_term = true
          clean_attrs["#{field_name}_attributes"].each do |term, properties|
            if properties.key?("_destroy") && !properties["_destroy"].blank?
              null_term = false
              break
            end
          end

          if null_term
            env.curation_concern.public_send("#{field_name}=", [])
          end
        end
      end
    end
  end
end

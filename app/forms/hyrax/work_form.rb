# Generated via
#  `rails generate hyrax:work Work`
module Hyrax
  class WorkForm < Hyrax::Forms::WorkForm
    self.model_class = ::Work
    
    include ScoobySnacks::WorkFormBehavior

    # OVERRIDE: Do not handle dateCreatedIngest in form; it is for ingest purposes only
    self.terms -= [:dateCreatedIngest]

    self.terms.each do |term|
      delegate term, to: :model
    end

    # OVERRIDE: Do not display dateCreatedIngest input in form; it is for ingest purposes only
    def secondary_terms
      super - [:dateCreatedIngest]
    end

# OVERRIDE FILE from ScoobySnacks to fix unpermitted_params error when saving a new work / Sara G. & Summer
    def self.build_permitted_params
        permitted = super
        ScoobySnacks::METADATA_SCHEMA.controlled_field_names.each do |field_name|
          permitted << {"#{field_name}_attributes".to_sym => [:id, :_destroy]}
        end
        permitted << :visibility
        permitted << {:in_works_ids => [:id, :_destroy]}
        permitted << :admin_set_id 
        permitted << :member_of_collection_ids
        permitted << :permissions_attributes
        permitted << :visibility_during_embargo
        permitted << :embargo_release_date
        permitted << :visibility_after_embargo
        permitted << :visibility_during_lease
        permitted << :lease_expiration_date
        permitted << :visibility_after_lease
        return permitted
    end
    
  end
end

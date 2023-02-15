class TextboxAutosuggestInput < ControlledVocabularyInput
  include ControlledIndexerBehavior
#  private
  
  #override this function to handle string value
  def build_field(value, index)
    # Bulkrax-ScoobySnacks conflicts means some values here are not yet ActiveTriples
    # This might be an unresolved bug from models/concerns/bulkrax/has_local_processing.rb
    case value
      when URI::regexp
        # Turn URI's into the expected ActiveTriples Resource object
        cleaned_url = ::WorkIndexer.sanitize_url(value)
        value = ActiveTriples::Resource.new(cleaned_url)
      when String
        # Strings are local vocab terms still in need of creation.
        field = ::ScoobySnacks::METADATA_SCHEMA.get_field(input_html_options[:data]['field-name'])
        subauth_name = get_subauthority_for(field: field, authority_name: 'local')
        url = mint_local_auth_url(subauth_name, value)
        value = ActiveTriples::Resource.new(url)
    end
    super(value, index) + raw("<span class=\"glyphicon glyphicon-floppy-disk\"></span>") + raw("<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span></button>")  + raw("<button type=\"button\" style=\"display:none\" class=\"btn btn-link restore\"><span class=\"glyphicon glyphicon-share-alt\"></span></button>")
  end

 def build_options_for_existing_row(_attribute_name, _index, value, options)
   options[:value] = ::WorkIndexer.fetch_remote_label(value) || "Unable to fetch label for #{value.rdf_subject}"
   options[:readonly] = true
   return options
 end

end

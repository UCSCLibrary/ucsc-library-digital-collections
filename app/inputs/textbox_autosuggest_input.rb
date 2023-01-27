class TextboxAutosuggestInput < ControlledVocabularyInput
#  private
  
  #override this function to handle string value
  def build_field(value, index)
    options = input_html_options.dup
    value = value.resource if value.is_a? ActiveFedora::Base

    build_options(value, index, options) if value.respond_to?(:rdf_label)
    options[:required] = nil if @rendered_first_element
    options[:class] ||= []
    options[:class] += ["#{input_dom_id} form-control multi-text-field"]
    options[:'aria-labelledby'] = label_id
    @rendered_first_element = true
    if value.is_a? String
      options[:value] = ::WorkIndexer.fetch_remote_label(value) || "Unable to fetch label for #{value}"
      options[:readonly] = true
      text_field(options) + raw("<span class=\"glyphicon glyphicon-floppy-disk\"></span>") + raw("<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span></button>")  + raw("<button type=\"button\" style=\"display:none\" class=\"btn btn-link restore\"><span class=\"glyphicon glyphicon-share-alt\"></span></button>")
    else
      text_field(options) + hidden_id_field(value, index) + destroy_widget(attribute_name, index) + raw("<span class=\"glyphicon glyphicon-floppy-disk\"></span>") + raw("<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span></button>")  + raw("<button type=\"button\" style=\"display:none\" class=\"btn btn-link restore\"><span class=\"glyphicon glyphicon-share-alt\"></span></button>")
    end
  end

 def build_options_for_existing_row(_attribute_name, _index, value, options)
   options[:value] = ::WorkIndexer.fetch_remote_label(value) || "Unable to fetch label for #{value.rdf_subject}"
   options[:readonly] = true
   return options
 end

end

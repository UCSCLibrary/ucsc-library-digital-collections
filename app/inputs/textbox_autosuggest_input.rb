class TextboxAutosuggestInput < ControlledVocabularyInput
#  private
  
  def build_field(value, index)
    super(value, index) + raw("<span class=\"glyphicon glyphicon-floppy-disk\"></span>") + raw("<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span></button>")  + raw("<button type=\"button\" style=\"display:none\" class=\"btn btn-link restore\"><span class=\"glyphicon glyphicon-share-alt\"></span></button>")
  end

 def build_options_for_existing_row(_attribute_name, _index, value, options)
   options[:value] = ::WorkIndexer.fetch_remote_label(value) || "Unable to fetch label for #{value.rdf_subject}"
   options[:readonly] = true
   return options
 end

end

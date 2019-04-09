class ControlledDropdownInput < ControlledVocabularyInput
#  private

  def schema
    ::ScoobySnacks::METADATA_SCHEMA
  end
  
  def build_field(value, index) 
    field = schema.get_field(attribute_name.to_s)
    auth_name = field.primary_vocabulary["subauthority"]
    options = input_html_options.dup
    value = value.resource if value.is_a? ActiveFedora::Base
    build_options(value, index, options) if value.respond_to?(:rdf_label)
    
    options[:name] = ""
    options[:selected] = options[:value]
    options.delete(:value)

    options[:class] ||= []
    options[:class] += ["#{input_dom_id} form-control dropdown"]

    options[:data] = {stored: options[:selected], 
                      name: name_for(attribute_name.to_s, index, "id")}
    # Include a blank option 
    # so that a nonselected entry doesn't look confusing in new works forms)
    options[:include_blank] = :true

    # Set the options for the dropdown itself
    vocab = field.vocabularies.first 
    vocab = {"authority" => "local", "subauthority" => vocab} if vocab.is_a? String 
    options['aria-labelledby'] = label_id
    
    collection =  Hyrax::QaSelectService.new(vocab["subauthority"]).select_all_options

    rv = @builder.collection_select(attribute_name,collection,:last,:first,options, options)
    rv = rv + destroy_widget(attribute_name, index)
    return rv
  end

end

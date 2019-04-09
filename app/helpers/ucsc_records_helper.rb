module UcscRecordsHelper

    def render_edit_field_partial_ucsc(field_name, locals)

    schema = ScoobySnacks::METADATA_SCHEMA
    field = schema.get_field(field_name.to_s)
    f = locals[:f]
    options = {label: field.label,
               required: f.object.required?(field_name),
               input_html: {class:'form-control'}}
    options[:hint] = field.definition if field.definition

    case (input_style = field.input.underscore)
    when "dropdown"
      # fields using dropdowns only pull from a single authority for now

      # use the custom input for local controlled vocab dropdowns
      options[:as] = :controlled_dropdown

    when "textbox_autosuggest"

      # render using the custom form input
      options[:as] = :textbox_autosuggest

      vocabularies = field.vocabularies || [field.vocabulary]
      
      #Create options for authority select text box
      Rails.logger.debug "here are some vocabularies:"
      Rails.logger.debug vocabularies.inspect
      
      authority_options = vocabularies.reject{|voc| voc['authority'].nil? || voc['subauthority'].nil?}.map{|voc| [voc['authority'].titleize+" "+voc['subauthority'].titleize, 
                                                  "/authorities/search/#{voc['authority']}/#{voc['subauthority']}"]} 

      data = {'autocomplete-url' => authority_options.first.last,
              'autocomplete' => field_name,
              'authority-select' => "#{field_name.to_s.underscore}_auth_select",
              'authorities' => authority_options,
              'input-style' => input_style,
              'persisted' => true }

      #add classes and data to relevant html elements
      options[:input_html] = {class: "form-control #{field_name.to_s.underscore}-input", data: data}
      options[:wrapper_html] = {data: data.merge!({'field-name' => field_name})}
    else
      # render as a string scalar
      options[:as] = f.object.multiple?(field_name) ? :multi_value : :string 
    end

    render_edit_field_partial(field_name,locals.merge({input_options: options}))
  end
end

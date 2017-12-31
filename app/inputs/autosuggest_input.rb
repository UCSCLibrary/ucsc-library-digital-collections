class AutosuggestInput < MultiValueInput

#  private
  
  def input(wrapper_options)
    @rendered_first_element = false
    input_html_classes.unshift('string')
    input_html_options[:name] ||= "#{object_name}[#{attribute_name}][]"
    
    puts "yo"
    puts "collection: #{collection}"

    outer_wrapper do
      buffer_each(collection) do |value, index|
        inner_wrapper do
          build_field(value, index)
        end
      end
    end
  end

  def build_field(value, index)

    options = input_html_options.dup
    value = value.resource if value.is_a? ActiveFedora::Base

    build_options(value, index, options)
    options[:required] = nil if @rendered_first_element
    options[:class] ||= []
    options[:class] += ["#{input_dom_id} form-control multi-text-field"]
    options[:'aria-labelledby'] = label_id

    Rails.logger.info "xfield options: "+options.inspect

    @rendered_first_element = true

    authority_picker(options) + text_field(options) + hidden_id_field(value, index) + destroy_widget(attribute_name, index)

    puts "Test thing!!!"

  end


  def retrieve_label(uri)
    Rails.logger.info "Fetching #{resource.rdf_subject} from the authorative source. (this is slow)"
    Active
    Ucsc::ControlledVocabularies::Person.new(uri).fetch().rdf_label.first.to_s
  rescue IOError, SocketError => e
    # IOError could result from a 500 error on the remote server
    # SocketError results if there is no server to connect to
    Rails.logger.error "Unable to fetch #{resource.rdf_subject} from the authorative source.\n#{e.message}"
  end

  def authority_picker(options)
    @builder.input(attribute_name.to_s + "_authority", 
                   as: :vocab_select, 
                   collection: options[:data]['authority-select'],
                   include_blank: false, 
                   label: false,
                   class: "authority",
                   wrapper: false,
                   :input_html => { :class => 'authority' })
  end

  def text_field(options)
    if options.delete(:type) == 'textarea'
      @builder.text_area(attribute_name, options)
    else
      @builder.text_field(attribute_name, options)
    end
  end

  def id_for_hidden_label(index)
    id_for(attribute_name, index, 'hidden_label')
  end

  def destroy_widget(attribute_name, index)
    @builder.hidden_field(attribute_name,
                          name: name_for(attribute_name, index, '_destroy'),
                          id: id_for(attribute_name, index, '_destroy'),
                          value: '', data: { destroy: true })
  end

  def hidden_id_field(value, index)
    name = name_for(attribute_name, index, 'id')
    id = id_for(attribute_name, index, 'id')
    if value.instance_of? String
      hidden_value = ''
    else
      hidden_value = value.node? ? '' : value.rdf_subject
    end
    @builder.hidden_field(attribute_name, name: name, id: id, value: hidden_value, data: { id: 'remote' })
  end

  def build_options(value, index, options)
    Rails.logger.error("value: "+value.to_s)
    options[:name] = name_for(attribute_name, index, 'hidden_label')
    options[:data] ||= {}
    options[:data][:attribute] = attribute_name
    options[:id] = id_for_hidden_label(index)
    if value.node?
      build_options_for_new_row(attribute_name, index, options)
    else
      build_options_for_existing_row(attribute_name, index, value, options)
    end
  end

  def build_options_for_new_row(_attribute_name, _index, options)
    options[:value] = ''
  end

  def build_options_for_existing_row(_attribute_name, _index, value, options)
    if value.is_a? String
      options[:value] = retrieve_label(value)
    else
      value.fetch()
      options[:value] = value.rdf_label.first.to_s || "Unable to fetch label for #{value.rdf_subject}"
    end
    options[:readonly] = true
  end

  def name_for(attribute_name, index, field)
    "#{@builder.object_name}[#{attribute_name}_attributes][#{index}][#{field}]"
  end

  def id_for(attribute_name, index, field)
    [@builder.object_name, "#{attribute_name}_attributes", index, field].join('_')
  end

  def collection
    @collection ||= begin
                      val = object[attribute_name]
                      col = val.respond_to?(:to_ary) ? val.to_ary : val
#                      col = [Ucsc::ControlledResource.new()] if col.empty?
                      col.reject { |value| value.to_s.strip.blank? }
                    end
  end
end

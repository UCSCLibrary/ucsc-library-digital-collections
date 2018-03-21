class MultiControlledVocabularyInput < ControlledVocabularyInput
#  private
  
  def build_field(value, index)
#    options = input_html_options.dup
#    authority_picker(options[:data]['authority-select']) + super
    super(value, index)
  end
 
#  def authority_picker(options)
#    @builder.input(attribute_name.to_s + "_auth_select", 
#                   as: :vocab_select, 
#                   collection: options[:data]['authority-select'],
#                   include_blank: false, 
#                   label: false,
#                   class: "authority",
#                   wrapper: false,
#                   :input_html => { :class => 'authority' })
#  end
end

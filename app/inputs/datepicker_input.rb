class DatepickerInput < SimpleForm::Inputs::StringInput 
  def input(value)
    input_html_options[:value] = value
    # sets the input type to date to use the native rails datepicker
    input_html_options[:type] = "date"
    # allows a blank value to be included
    input_html_options[:include_blank] = true
    # sets the input type to multiple
    input_html_options[:multiple] = true
    super
  end
end
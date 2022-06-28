class DatepickerInput < SimpleForm::Inputs::StringInput
  def input_html_options
    # reject empty strings since [""].blank? == false
    value = object.send(attribute_name).reject(&:blank?)
    options = {
      value: value.blank? ? nil : I18n.localize(value[0].to_date),
      data: { behaviour: 'datepicker' },
      type: 'date',
      multiple: true
    }
    super.merge options
  end
end

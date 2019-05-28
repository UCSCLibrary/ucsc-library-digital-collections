import ControlledVocabInput from 'hyrax/editor/controlled_vocab_input'

export default class Dropdown extends ControlledVocabInput {

  get_input_source() {
    return "<input class=\"string {{class}} optional form-control {{paramKey}}_{{name}} form-control multi-text-field\" name=\"{{paramKey}}[{{name}}_attributes][{{index}}][hidden_label]\" value=\"\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}_hidden_label\" data-attribute=\"{{name}}\" type=\"text\">"
  }


}

import ControlledVocabInput from 'hyrax/editor/controlled_vocab_input'
import LinkedData from 'hyrax/autocomplete/linked_data'

export default class TextboxAutosuggest extends ControlledVocabInput {

  get_input_source() {
    return "<input class=\"string {{class}} optional textbox_autosuggest form-control {{paramKey}}_{{name}} multi-text-field\" name=\"{{paramKey}}[{{name}}_attributes][{{index}}][hidden_label]\" value=\"\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}_hidden_label\" data-attribute=\"{{name}}\" data-persisted=false type=\"text\">"
  }

  /**
   * @param {jQuery} $newField - The <li> tag
   */
  _addBehaviorsToInput(element) {

    let textbox = $('input.multi-text-field', element)
    textbox.focus()

    //link the text box to the primary authority
    new LinkedData(textbox,this.primary_vocabulary_endpoint)

    //when you make a selection from the autosuggest, hide the authority control and mark it selected
    textbox.on('change',function(){
      $(this).siblings('div.auth-select-div').hide()
      $(this).addClass('selected')
    })

    // When you select a new authority, link the text box to the new authority
    if (this.multiple_vocabularies) {
      $('select.auth-select',element).change(function(){
        textbox.select2("destroy")
        textbox.off("change")
        new LinkedData(textbox,$(this).val())
        textbox.on('change',function(){
          $(this).siblings('div.auth-select-div').hide()
        })
      })
    }
    super._addBehaviorsToInput(element)
  }
}



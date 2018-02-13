

import { FieldManager } from 'hydra-editor/field_manager'
//import Handlebars from 'handlebars'
import Autocomplete from 'hyrax/autocomplete'
import AuthoritySelect from 'hyrax/authority_select'

export default class MultiControlledVocabulary extends FieldManager {

  constructor(element, paramKey) {
    let options = {
      /* callback to run after add is called */
      add:    null,
      /* callback to run after remove is called */
      remove: null,

      controlsHtml:      '<span class=\"input-group-btn field-controls\">',
      fieldWrapperClass: '.field-wrapper',
      warningClass:      '.has-warning',
      listClass:         '.listing',
      inputTypeClass:    '.multi_controlled_vocabulary',

      addHtml:           '<button type=\"button\" class=\"btn btn-link add\"><span class=\"glyphicon glyphicon-plus\"></span><span class="controls-add-text"></span></button>',
      addText:           'Add another',

      removeHtml:        '<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span><span class="controls-remove-text"></span> <span class=\"sr-only\"> previous <span class="controls-field-name-text">field</span></span></button>',
      removeText:         'Remove',

      labelControls:      true,
    }
    console.log("options: "+options)
    super(element, options)
    this.paramKey = paramKey
    this.fieldName = this.element.data('field-name')
    this.searchUrl = this.element.data('autocompleteUrl')
    this.authorities = this.element.data('authority-select')
  }


  // Overrides FieldManager in order to avoid doing a clone of the existing field
  createNewField($activeField) {
    let $newField = this._newFieldTemplate()
    console.log("new field: "+$newField.html())
    this._addBehaviorsToInput($newField)
    this.element.trigger("managed_field:add", $newField);
    return $newField
  }

  /* This gives the index for the editor */
  _maxIndex() {
    return $(this.fieldWrapperClass, this.element).size()
  }

  // Overridden because we always want to permit adding another row
  inputIsEmpty(activeField) {
    return false
  }

  _newFieldTemplate() {
    let index = this._maxIndex()
    let rowTemplate = this._template
    let controls = this.controls.clone()//.append(this.remover)
    console.log("paramkey: "+this.paramKey)
    let row =  $(rowTemplate({ "paramKey": this.paramKey,
                               "name": this.fieldName,
                               "index": index,
                               "class": "multi_controlled_vocabulary",
                               "authorities": this.authorities}))
        .append(controls)
    return row
  }

  get _source() {
    
//      return "<li class=\"field-wrapper input-group input-append\">" +
//        "<input class=\"string {{class}} optional form-control {{paramKey}}_{{name}} form-control multi-text-field\" name=\"{{paramKey}}[{{name}}_attributes][{{index}}][hidden_label]\" value=\"\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}_hidden_label\" data-attribute=\"{{name}}\" type=\"text\">" +
//        "<input name=\"{{paramKey}}[{{name}}_attributes][{{index}}][id]\" value=\"\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}_id\" type=\"hidden\" data-id=\"remote\">" +
//        "<input name=\"{{paramKey}}[{{name}}_attributes][{{index}}][_destroy]\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}__destroy\" value=\"\" data-destroy=\"true\" type=\"hidden\"></li>"
    return "<p>test?</p>"
  }

  _template(args) {
//    return Handlebars.compile(this._source)
    var auths = args['authorities']
    var template = '<li class="field-wrapper input-group input-append">'
    
    template += '<select name="'+args['name']+'_authority" id="'+args['name']+'_authority" class="form-control dummy_select optional authority">'
    for (var i = 0; i< auths.length; i++) {
      template += '<option value = "'+auths[i][1]+'">'+auths[i][0]+'</option>'
    }
    template += '<option value="http://loc/etc">loc</option>'
    template += '</select>'

    template += '<input class="string '+args['class']+' optional form-control '+args['paramKey']+'_'+args['name']+' form-control multi-text-field" name="'+args['paramKey']+'['+args['name']+'_attributes]['+args['index']+'][hidden_label]" value="" id="'+args['paramKey']+'_'+args['name']+'_attributes_'+args['index']+'_hidden_label" data-attribute="'+args['name']+'" type="text">'
    template += '<input name="'+args['paramKey']+'['+args['name']+'_attributes]['+args['index']+'][id]" value="" id="'+args['paramKey']+'_'+args['name']+'_attributes_'+args['index']+'_id" type="hidden" data-id="remote">'
    template += '<input name="'+args['paramKey']+'['+args['name']+'_attributes]['+args['index']+'][_destroy]" id="'+args['paramKey']+'_'+args['name']+'_attributes_'+args['index']+'__destroy" value="" data-destroy="true" type="hidden">'
    template += '</li>'

    return template
  }

  /**
   * @param {jQuery} $newField - The <li> tag
   */
  _addBehaviorsToInput($newField) {
    let $newInput = $('input.multi-text-field', $newField)
    $newInput.focus()
    this.addAutocompleteToEditor($newInput)
    this.element.trigger("managed_field:add", $newInput)
  }

  /**
   * Make new element have autocomplete behavior
   * @param {jQuery} input - The <input type="text"> tag
   */
  addAutocompleteToEditor(input) {
    var autocomplete = new Autocomplete()
    autocomplete.setup(input, this.fieldName, this.searchUrl)
  }

  // Overrides FieldManager
  // Instead of removing the line, we override this method to add a
  // '_destroy' hidden parameter
  removeFromList( event ) {
    event.preventDefault()
    let field = $(event.target).parents(this.fieldWrapperClass)
    field.find('[data-destroy]').val('true')
    field.hide()
    this.element.trigger("managed_field:remove", field)
  }
}

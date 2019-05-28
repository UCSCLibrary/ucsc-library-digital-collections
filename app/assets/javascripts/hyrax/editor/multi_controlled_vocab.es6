import { FieldManager } from 'hydra-editor/field_manager'
import TextboxAutosuggest from "./textbox_autosuggest"
import Dropdown from "./dropdown"

export default class MultiControlledVocab extends FieldManager {

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
      inputTypeClass:    '.'+$(element).data('inputStyle'),

      addHtml:           '<button type=\"button\" class=\"btn btn-link add\"><span class=\"glyphicon glyphicon-plus\"></span><span class="controls-add-text"></span></button>',
      addText:           'Add another ',

      labelControls:      true,
    }
    super(element, options)
    this.inputStyle = this.element.data('inputStyle')
    this.paramKey = paramKey
    this.fieldName = this.element.data('fieldName')
    this.authOptions = this.element.data('authorities')
    this.addRemoveBehavior(element)
  }

  addRemoveBehavior(element) {
    $('button.remove',element).click(function(){
      let destructor = $(this).siblings('input[name*=destroy]')
      destructor.val(true)
      destructor.prop('disabled',false)
      $(this).siblings('input.form-control').css('text-decoration','line-through')
      $(this).siblings('button.restore').show()
      $(this).hide()
    })

    $('button.restore',element).click(function(){
      let destructor = $(this).siblings('input[name*=destroy]')
      destructor.val("")
      destructor.prop('disabled','disabled')
      $(this).siblings('input.form-control').css('text-decoration','inherit')
      $(this).siblings('button.remove').show()
      $(this).hide()
    })
  }

  // Overrides FieldManager in order to avoid doing a clone of the existing field
  createNewField($activeField) {
    console.log("switching on: "+this.inputStyle.underscore)
    switch (this.inputStyle.underscore) {
    case "dropdown":
      return new Dropdown(this._maxIndex(),this.element, this.paramKey);
      break;
    case "textbox_autosuggest":
      return new TextboxAutosuggest(this._maxIndex(),this.element, this.paramKey);
      break;
    default: 
      return new TextboxAutosuggest(this._maxIndex(),this.element, this.paramKey);
      break;
    }

  }

  /* This gives the index for the editor */
  _maxIndex() {
    return $(this.fieldWrapperClass, this.element).length
  }

  // Overridden because we always want to permit adding another row
  inputIsEmpty(activeField) {
    return false 
  }

  // Override to NOT attached standard add and remove events
 _attachEvents() {
   this.element.on('click', this.addSelector, (e) => this.addToList(e))
 }

   // override to NOT add a global remove control
    _appendControls() {
        // We want to make these DOM additions idempotently, so exit if it's
        // already set up.
        if (!this._hasAddControl()) {
          this._createAddControl()
        }
    }
}

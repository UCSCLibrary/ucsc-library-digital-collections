import ControlledVocabulary from 'hyrax/editor/controlled_vocabulary'
import Handlebars from 'handlebars'
import LinkedData from 'hyrax/autocomplete/linked_data'

export default class MvcLine {

  constructor(index,parent,paramKey) {

    this.parentElement = parent
    this.fieldName = parent.data('fieldName')
    this.id = this.fieldName + '-' + index
    this.searchUrl = this.parentElement.data('autocompleteUrl')
    this.authOptions = this.parentElement.data('authorities')

    let rowTemplate = Handlebars.compile(this._source)
    let newElement =  $(rowTemplate({ "paramKey": paramKey,
                               "name": this.fieldName,
                               "index": index,
                               "class": "multi_controlled_vocabulary" }))
    this.parentElement.append(newElement)
    this._addBehaviorsToInput(newElement)

    this.parentElement.trigger("managed_field:add", newElement);

    return newElement
  }

  get _source() {

    return "<li id=\""+ this.id +"\" class=\"field-wrapper input-group input-append\" data-persisted=false>" +
      "<div class=auth-select-div><label>Authority:</label><select class=\"auth-select {{name}}_auth_select\">" + 
      this._authSelectOptions() + 
      "</select></div>" + 
      "<input class=\"string {{class}} optional form-control {{paramKey}}_{{name}} form-control multi-text-field\" name=\"{{paramKey}}[{{name}}_attributes][{{index}}][hidden_label]\" value=\"\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}_hidden_label\" data-attribute=\"{{name}}\" type=\"text\">" +
      "<input name=\"{{paramKey}}[{{name}}_attributes][{{index}}][id]\" value=\"\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}_id\" type=\"hidden\" data-id=\"remote\">" +
      "<input name=\"{{paramKey}}[{{name}}_attributes][{{index}}][_destroy]\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}__destroy\" class=\"destructor\" value=\"\" data-destroy=\"true\" type=\"hidden\">" + 
      "<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span><span class=\"controls-remove-text\"></span> <span class=\"sr-only\"> previous <span class=\"controls-field-name-text\">field</span></span></button></li>" + 
      "<span class=\"input-group-btn field-controls\">"

  }


  _thisElement() {
    $("#"+this.id)
  }

  _authSelectOptions() {
    let rv = "";
    for (var option of this.authOptions){
      rv = rv + this._authSelectOption(option[0],option[1])
    }
    return rv
  }

  _authSelectOption(name,value) {
    return "<option value=\""+value+"\">"+name+"</option>"
  }


  /**
   * @param {jQuery} $newField - The <li> tag
   */
  _addBehaviorsToInput(element) {
    this._addDeleteBehavior(element)

    let textbox = $('input.multi-text-field', element)
    textbox.focus()

    let authSelect = $('select.auth-select',element)

    new LinkedData(textbox,authSelect.val())

    textbox.on('change',function(){
      $(this).siblings('div.auth-select-div').hide()
    })

    authSelect.change(function(){
      textbox.select2("destroy")
      textbox.off("change")
      new LinkedData(textbox,$(this).val())
      textbox.on('change',function(){
        $(this).siblings('div.auth-select-div').hide()
      })
    })

  }


  _addDeleteBehavior(element) {
    let $deleteButton = $('button.remove',element)
    var id = this.id
    $deleteButton.click(function(){$("#"+id).remove()})
  }

  _removeElement() {
    if (this.element.data("persisted") == "false") {
      $deleteButton.click($newField.remove())
    } else {
      let $deleteInput = $('input.desctructor',this.element)
      $deleteInput.val(true)
      this.element.hide()
    }
    this.element.trigger("managed_field:remove", field)
  }



}

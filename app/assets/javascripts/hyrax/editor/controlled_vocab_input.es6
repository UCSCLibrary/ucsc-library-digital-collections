import ControlledVocabulary from 'hyrax/editor/controlled_vocabulary'
import Handlebars from 'handlebars'

export default class ControlledVocabInput {

  constructor(index,parent,paramKey) {

    this.parentElement = parent
    this.fieldName = parent.data('fieldName')
    this.id = this.fieldName + '-' + index
    this.searchUrl = this.parentElement.data('autocompleteUrl')
    this.authOptions = this.parentElement.data('authorities')
    this.multiple_vocabularies = (this.authOptions.length > 1) 
    let rowTemplate = Handlebars.compile(this._source)
    let newElement =  $(rowTemplate({ "paramKey": paramKey,
                                      "name": this.fieldName,
                                      "index": index,
                                      "class": "controlled_vocabulary" }))
    this.parentElement.children('ul').append(newElement)
    this._addBehaviorsToInput(newElement)

    this.parentElement.trigger("managed_field:add", newElement);

    return newElement
  }

  get_auth_select_source() {
    return "<div class=auth-select-div><label>Authority:</label><select class=\"auth-select {{name}}_auth_select\">" + 
      this._authSelectOptions() + 
      "</select></div>"
  }

  get_input_source() {
    return "<input class=\"string {{class}} optional form-control {{paramKey}}_{{name}} \" name=\"{{paramKey}}[{{name}}_attributes][{{index}}][hidden_label]\" value=\"\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}_hidden_label\" data-attribute=\"{{name}}\" type=\"text\">"
  }

  get_hidden_id_source() {
    return "<input name=\"{{paramKey}}[{{name}}_attributes][{{index}}][id]\" value=\"\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}_id\" type=\"hidden\" data-id=\"remote\">"
  }

  get_hidden_destructor_source() {
    return "<input name=\"{{paramKey}}[{{name}}_attributes][{{index}}][_destroy]\" id=\"{{paramKey}}_{{name}}_attributes_{{index}}__destroy\" class=\"destructor\" value=\"\" data-destroy=\"true\" type=\"hidden\">"
  }

  get_remove_button_source() {
     return "<button type=\"button\" class=\"btn btn-link remove\"><span class=\"glyphicon glyphicon-remove\"></span><span class=\"controls-remove-text\"></span> <span class=\"sr-only\"> previous <span class=\"controls-field-name-text\">field</span></span></button>"
  }

  get _source() {
    var source;
    source = "<li id=\""+ this.id +"\" class=\"metadata-entry field-wrapper input-group input-append\" data-persisted=false>"
    if (this.multiple_vocabularies)
      source += this.get_auth_select_source()
    source += this.get_input_source()
    source += this.get_hidden_id_source()
    source += this.get_hidden_destructor_source()
    source += this.get_remove_button_source()
    source += "</li>"
    source += "<span class=\"input-group-btn field-controls\">"
    return source
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
  }

  _addDeleteBehavior(element) {
    // delete the whole li element if you hit the remove button
    // (this only applies to elements added in javascript, so they
    //  don't need to be removed from Fedora)
    let $deleteButton = $('button.remove',element)
    var id = this.id
    $deleteButton.click(function(){$("#"+id).remove()})
  }

}

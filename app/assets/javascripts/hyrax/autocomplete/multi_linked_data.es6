// Autocomplete for linked data elements
// After selecting something, the selected item is immutable

export default class MultiLinkedData {
  constructor(element) {
    this.select = element.siblings('select.authority')
    this.element = element
    console.log("html: "+jQuery(element).html())
    this.activate()
  }

  startComplete(){
    this.element
      .select2(this.options(this.element, this.select.val()))
      .on("change", (e) => { this.selected(e) })
  }

  activate() {
    this.element.before('')
    this.startComplete()
    console.log("select value: "+this.select.val());
    this.select[0].addEventListener('change', this.startComplete.bind(this))
  }

  // Called when a choice is made
  selected(e) {
    let result = this.element.select2("data")
    this.element.siblings("select").remove()
    this.element.select2("destroy")
    this.element.val(result.label).attr("readonly", "readonly")
    this.setIdentifier(result.id)
  }

  
  // Store the uri in the associated hidden id field
  setIdentifier(uri) {
    this.element.closest('.field-wrapper').find('[data-id]').val(uri);
  }

  options(element,url=false) {
    if (!url) {url=this.url}
    return {
      // placeholder: $(this).attr("value") || "Search for a location",
      minimumInputLength: 2,
      id: function(object) {
        return object.id;
      },
      text: function(object) {
        return object.label;
      },
      // initSelection: function(element, callback) {
      //   // Called when Select2 is created to allow the user to initialize the
      //   // selection based on the value of the element select2 is attached to.
      //   // Essentially this is an id->object mapping function.
      //   var data = {
      //     id: element.val(),
      //     text: element.val()
      //   };
      //   callback(data);
      // },
      ajax: { // Use the jQuery.ajax wrapper provided by Select2
        url: url,
        dataType: "json",
        data: function (term, page) {
          return {
            q: term // Search term
          };
        },
        results: function(data, page) {
          return { results: data };
        }
      }
    }
  }
}

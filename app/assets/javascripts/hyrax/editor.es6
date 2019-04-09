import RelationshipsControl from 'hyrax/relationships/control'
import SaveWorkControl from 'hyrax/save_work/save_work_control'
import AdminSetWidget from 'hyrax/editor/admin_set_widget'
import MultiControlledVocab from 'hyrax/editor/controlled_vocab'
import Dropdown from 'hyrax/editor/dropdown'

export default class {
  /**
   * initialize the editor behaviors
   * @param {jQuery} element - The form that has a data-param-key attribute
   */
  constructor(element) {
    this.element = element
    this.paramKey = element.data('paramKey') // The work type
    this.adminSetWidget = new AdminSetWidget(element.find('select[id$="_admin_set_id"]'))
    this.sharingTabElement = $('#tab-share') 
  }

  init() {
    this.fixNewElements()
    this.controlledVocabularies()
    this.sharingTab()
    this.relationshipsControl()
    this.saveWorkControl()
    this.saveWorkFixed()
  }

  // Autocomplete fields for the work edit form 
  fixNewElements() {
    $('.multi_value.form-group').manage_fields({
      add: function(e, element) {
        var elem = $(element)
        elem.attr('readonly', false)
      }
    })
  }

  // initialize any controlled vocabulary widgets
  controlledVocabularies() {
    this.element.find('.textbox_autosuggest.form-group').each((_idx, controlled_field) =>
      new MultiControlledVocab(controlled_field, this.paramKey)
    )
    this.element.find('.controlled_dropdown.form-group select').each((_idx, controlled_dropdown) =>
      $(controlled_dropdown).change(function(){
        console.log("thing changed")
        var destructor = $(this).siblings("input")
        // If the new value is the same as the one stored in the DB
        if(this.value == $(this).data("stored")) {
          // disable the destructor and remove the element name so it won't submit
          destructor.val("");
          $(this).attr("name","")
        } else {
          // If we've picked something new, enable the desctructor and name the element
          destructor.val("true")
          if (this.value == "")
            $(this).attr("name","")
          else
            $(this).attr("name", $(this).data("name"))

        }
      }))
  }

  // Display the sharing tab if they select an admin set that permits sharing
  sharingTab() {
    if(this.adminSetWidget && !this.adminSetWidget.isEmpty()) {
      this.adminSetWidget.on('change', () => this.sharingTabVisiblity(this.adminSetWidget.isSharing()))
      this.sharingTabVisiblity(this.adminSetWidget.isSharing())
    }
  }

  sharingTabVisiblity(visible) {
      if (visible)
         this.sharingTabElement.removeClass('hidden')
      else
         this.sharingTabElement.addClass('hidden')
  }

  relationshipsControl() {
    let collections = this.element.find('[data-behavior="collection-relationships"]')
    collections.each((_idx, element) =>
                     new RelationshipsControl(element,
                                              collections.data('members'),
                                              collections.data('paramKey'),
                                              'member_of_collections_attributes',
                                              'tmpl-collection').init())

    let works = this.element.find('[data-behavior="child-relationships"]')
    works.each((_idx, element) =>
               new RelationshipsControl(element,
                                        works.data('members'),
                                        works.data('paramKey'),
                                        'work_members_attributes',
                                        'tmpl-child-work').init())
  }


  saveWorkControl() {
      new SaveWorkControl(this.element.find("#form-progress"), this.adminSetWidget)
  }

  saveWorkFixed() {
      // Fixedsticky will polyfill position:sticky
      this.element.find('#savewidget').fixedsticky()
  }
}

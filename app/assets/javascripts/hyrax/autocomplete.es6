import Default from './autocomplete/default'
import Work from './autocomplete/work'
import LinkedData from './autocomplete/linked_data'
import MultiLinkedData from './autocomplete/multi_linked_data'

export default class Autocomplete {
  /**
   * Setup for the autocomplete field.
   * @param {jQuery} element - The input field to add autocompete to
   # @param {string} fieldName - The name of the field (e.g. 'based_near')
   # @param {string} url - The url for the autocompete search endpoint
   */
  setup (element, fieldName, url) {
    switch (fieldName) {
      case 'work':
        new Work(
          element,
          url,
          element.data('exclude-work')
        )
        break
      case 'based_near':
        new LinkedData(element, url)
      case 'creator':
        new MultiLinkedData(element)
      default:
        new Default(element, url)
        break
    }
  }
}

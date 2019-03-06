import Default from 'hyrax/autocomplete/default'
import Resource from 'hyrax/autocomplete/resource'
import LinkedData from 'hyrax/autocomplete/linked_data'

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
        new Resource(
          element,
          url,
          element.data('exclude-work')
        )
        break
      case 'collection':
        new Resource(
          element,
          url)
        break     
      case 'based_near':
        new LinkedData(element, url)
      default:
        new Default(element, url)
        break
    }
  }
}

require 'spec_helper_derailed'

RSpec.feature 'Collection', js: false do
  context 'a guest user' do
    scenario do
      visit '/'
      first('li.featured-item img').click
      expect(page).to have_content "Collection Details"
      expect(page).to have_selector "div.document>div.thumbnail img"
    end
  end
end

require 'spec_helper_derailed'

RSpec.feature 'Search results', js: false do
  context 'a guest user' do
    scenario do
      visit '/catalog?q='
      expect(page).to have_selector "h3.facet-field-heading", text: "Creator"
      expect(page).to have_selector ".document>.thumbnail img"
      expect(page).to have_selector "ul.pagination", text: "Next"

      expect(page).to have_css('div.thumbnail img', count: 24)
      click_on '24 per page'
      click_on '20'
      expect(page).to have_css('div.thumbnail img', count: 20)
    end

    scenario do
      visit '/catalog'
      title = page.first('div.document div.caption').text.split.first
      expect(page).to have_selector "h3.index_title", text: title
      click_on 'Creator'
      first('a.facet_select').click
      expect(page).to have_selector "h3.index_title", text: title
    end

    
    scenario do
      visit '/advanced'
      expect(page).to have_selector "input#title"
# TODO Create works before running this test
#      fill_in 'Title', with: title
#      find('#advanced-search-submit').click
#      expect(page.first("div.document div.caption").text).to include title
    end
  end
end


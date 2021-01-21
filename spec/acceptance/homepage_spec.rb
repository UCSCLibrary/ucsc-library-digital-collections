
require 'spec_helper_derailed'

RSpec.feature 'A guest user visiting the site for the first time', js: false do
  scenario 'loads the homepage' do
    visit '/'
    expect(page).to have_content "UC Santa Cruz"
    expect(page).to have_content /University Library/i
    expect(page).to have_content "Accessibility Policy"
    expect(page).to have_content "Takedown Policy"
    expect(page).to have_content "Reproduction & Use"
    expect(page).to have_content "Digital Collections Login"
    expect(page).to have_content "About the UCSC Digital Collections"
    expect(page).to have_content "UCSC Library GitHub"
    expect(page).to have_content "Feedback"
    expect(page).to have_selector '#feedbackModal', visible: false
    expect(page).to have_content "Browse Collections"
    expect(page).to have_content "Contact Us"
    expect(page).to have_selector "input#search-field-header"
    # TODO add a featured collection before running this test
    #    expect(page).to have_selector 'li.featured-item img'
    click_on("Contact Us")
    expect(page).to have_css("form")
    expect(page).to have_content("FAQ")
  end
end

require 'rails_helper'
#include Warden::Test::Helpers

RSpec.feature 'Homepage', js: false do
  context 'a guest user' do
    scenario do
      visit '/'
      expect(page).to have_content "UC Santa Cruz University Library Digital Media Collection"
      expect(page).to have_content "Here's a test phrase"

      
    end
  end
end

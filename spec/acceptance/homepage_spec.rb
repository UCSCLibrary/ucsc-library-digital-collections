
require 'spec_helper_derailed'

RSpec.feature 'Homepage', js: false do
  context 'a guest user' do
    scenario do
      visit '/'
      expect(page).to have_content "UC Santa Cruz University Library Digital Media Collection"
    end
  end
end

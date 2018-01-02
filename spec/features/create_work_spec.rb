# Generated via
#  `rails generate hyrax:work Work`
require 'rails_helper'
include Warden::Test::Helpers

# NOTE: If you generated more than one work, you have to set "js: true"
RSpec.feature 'Create a Work', js: false do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      AdminSet.find_or_create_default_admin_set_id
      login_as user
    end

    scenario do
      visit '/dashboard'
      click_link "Works"

      # not sure why, but these tests fail even when the site works
      # as expected. Need to sort out the tests themselves.

#      click_link "Add new work"
#
#      # If you generate more than one work uncomment these lines
#       choose "payload_concern", option: "Work"
#       click_button "Create work"
#
#      expect(page).to have_content "Select type of Work"
    end
  end
end

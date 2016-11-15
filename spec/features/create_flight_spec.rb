# Generated via
#  `rails generate curation_concerns:work Flight`
require 'rails_helper'
include Warden::Test::Helpers

feature 'Create a Flight' do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      login_as user
    end

    scenario do
      visit new_curation_concerns_flight_path
      fill_in 'Title', with: 'Test Flight'
      click_button 'Create Flight'
      expect(page).to have_content 'Test Flight'
    end
  end
end

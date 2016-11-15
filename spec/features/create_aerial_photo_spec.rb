# Generated via
#  `rails generate curation_concerns:work AerialPhoto`
require 'rails_helper'
include Warden::Test::Helpers

feature 'Create a AerialPhoto' do
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
      visit new_curation_concerns_aerial_photo_path
      fill_in 'Title', with: 'Test AerialPhoto'
      click_button 'Create AerialPhoto'
      expect(page).to have_content 'Test AerialPhoto'
    end
  end
end

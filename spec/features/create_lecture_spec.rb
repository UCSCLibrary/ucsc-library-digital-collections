# Generated via
#  `rails generate curation_concerns:work Lecture`
require 'rails_helper'
include Warden::Test::Helpers

feature 'Create a Lecture' do
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
      visit new_curation_concerns_lecture_path
      fill_in 'Title', with: 'Test Lecture'
      click_button 'Create Lecture'
      expect(page).to have_content 'Test Lecture'
    end
  end
end

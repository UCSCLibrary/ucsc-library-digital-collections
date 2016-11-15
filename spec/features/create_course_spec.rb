# Generated via
#  `rails generate curation_concerns:work Course`
require 'rails_helper'
include Warden::Test::Helpers

feature 'Create a Course' do
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
      visit new_curation_concerns_course_path
      fill_in 'Title', with: 'Test Course'
      click_button 'Create Course'
      expect(page).to have_content 'Test Course'
    end
  end
end

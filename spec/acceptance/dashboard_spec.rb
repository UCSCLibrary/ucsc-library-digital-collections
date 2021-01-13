require 'rails_helper'

RSpec.feature 'An admin user navigating the dashboard' do

  before(:each) do
    admin_role = Role.find_by(name: "admin") || Role.create(name: "admin")
    if (@admin = Role.find_by(name:"admin").users.first).nil?
      @admin = create(:user)
      admin_role.users << @admin
      admin_role.save
    end
    visit '/users/sign_in'
    fill_in "user_email", with: @admin.email
    fill_in "user_password", with: "password"
    page.click_button('Log in')
    visit '/dashboard'
  end

  after(:each) do
    visit '/users/sign_out'
  end

  scenario 'views the main dashboard page' do
    expect(page).to have_content('Your activity')
    expect(page).to have_content('Works')
    expect(page).to have_content('Collections')
#   expect(page).to have_content('Review Submissions')
    expect(page).to have_content('Manage Users')
    expect(page).to have_content('Bulk Operations')
    expect(page).to have_content('Settings')
    expect(page).to have_content('Workflow Roles')
  end

  scenario 'views admin collections browse page' do
    click_on 'Collections'
    click_on "All Collections"
    expect(page).to have_css('td>div.thumbnail-title-wrapper')
  end

  scenario 'views admin works browse page' do
    create(:work)
    click_on 'Works'
    click_on "All Works"
    expect(page).to have_css('td>div.media img')
  end

  scenario 'views Manage Users page' do
    click_on 'Manage Users'
    expect(page).to have_content('Username')
    expect(page).to have_content('Last access')
    expect(page).to have_css('tbody tr')
  end

end


require 'spec_helper_derailed'

RSpec.feature 'An admin user navigating the dashboard' do
  
  before(:each) do
    visit '/users/sign_in'
    fill_in "user_email", with: "ethenry@ucsc.edu"
    fill_in "user_password", with: ENV['ADMIN_PASSWORD']
    page.click_button('Log in')
    visit '/dashboard'
  end
  
  scenario 'views the main dashboard page' do
    expect(page).to have_content('Your activity')
    expect(page).to have_content('Works')
    expect(page).to have_content('Collections')
    expect(page).to have_content('Review Submissions')
    expect(page).to have_content('Manage Users')
    expect(page).to have_content('Bulk Operations')
    expect(page).to have_content('Settings')
    expect(page).to have_content('Workflow Roles')
  end

  scenario 'views admin collections browse page' do
    click_on 'Collections'
    click_on "All Collections"
    expect(page).to have_css('td>div.thumbnail-title-wrapper', :count => 10)
  end


  scenario 'views admin works browse page' do
    click_on 'Works'
    click_on "All Works"
    expect(page).to have_css('td>div.media img', :count => 10)
  end


  scenario 'views review submissions page' do
    visit '/admin/workflows'
    expect(page).to have_css("div.panel>ul.nav-tabs li", count: 5)
    expect(page).to have_content('Select All')
    expect(page).to have_content('Request Changes')
    expect(page).to have_content('Approve')
    expect(page).to have_content('Complete')
  end

  scenario 'views Manage Users page' do
    click_on 'Manage Users'
    expect(page).to have_content('Username')
    expect(page).to have_content('Last access')
    expect(page).to have_css('tbody tr', :count => 10)
  end

end


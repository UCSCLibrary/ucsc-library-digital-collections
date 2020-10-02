require 'spec_helper_derailed'

RSpec.feature 'An admin user navigating the Bulk Ops menus', js: false do

  before(:each) do
    visit '/users/sign_in'
    fill_in "user_email", with: (ENV['ADMIN_USERNAME'] || 'ethenry@ucsc.edu')
    fill_in "user_password", with: ENV['ADMIN_PASSWORD']
    page.click_button('Log in')
  end

  
  scenario 'views the form to create a new Bulk Operation' do
    visit '/bulk_ops/new'
    expect(page).to have_content('Create New Bulk Ingest or Update')
    expect(page).to have_content('Works')
    expect(page).to have_content('Collections')
    expect(page).to have_content('Review Submissions')
    expect(page).to have_content('Manage Users')
    expect(page).to have_content('Bulk Operations')
    expect(page).to have_content('Settings')
    expect(page).to have_content('Workflow Roles')
  end


end


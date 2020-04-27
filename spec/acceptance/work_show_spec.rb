require 'spec_helper_derailed'

RSpec.feature 'Work Show page', js: false do
  
  context 'a guest user' do
    scenario 'views a single image' do
      visit '/concern/works/r494vk41k'
      expect(page).to have_css("img.raw-image.primary-media")
      expect(page).to have_content('Unknown photographer')
      expect(page).to have_content('In Collection')
      page.find('span#show-more-metadata a').click
      expect(page).to have_content('Cowell Beach')
      page.find("div.permalink a").click
      expect(page).to have_content('Ruth, Duke, Betty at Cowell Beach')
      click_button('Download')
      expect(page).to have_content('Rights Information:')
      expect(page).to have_content('Download Small (250px)')
      
    end

    scenario 'views a single image with universal viewer' do
      visit '/concern/works/r494vk41k?universal_viewer=true'
      expect(page).to have_css('div.uv>iframe')
    end

    scenario 'views a parent image (with child image works)' do
      visit '/concern/works/f7623g14k'
      expect(page).to have_css('.thumbnail img', :count => 23)
    end

    scenario 'views a child image' do
      visit '/concern/works/th83kz88z'
      expect(page).to have_css("img.raw-image.primary-media")
      expect(page).to have_link(href: '/records/t722hc13q')
      expect(page).to have_content("Portrait of a Town")
      expect(page).to have_content("35 mm")
      page.find('span#show-more-metadata a').click
      expect(page).to have_content("Regents of the University of California")
    end

    scenario 'views a compound image (with child image file_sets)' do
      visit '/concern/works/4b29b807k'
      expect(page).to have_css('div.uv>iframe')
#      expect(page).not_to have_css('div#download-share-cite>button')
    end

    scenario 'views a parent audio work' do
      visit '/concern/works/m613n0790'
      expect(page).to have_css('div#mep_0')
      expect(page).to have_css('div.av_playlist_link', :count => 50)
      expect(page).to have_css('div#div-4b29b8094.av_playlist_link.active')
    end

    scenario 'views a child audio work' do
      visit '/concern/works/q811km70v'
      expect(page).to have_css('div#mep_0')
      expect(page).to have_css('div.av_playlist_link', :count => 50)
      expect(page).to have_css('div#div-h989r561r.av_playlist_link.active')
    end
  end

  context 'a logged in admin' do
    scenario 'views a single image' do
      visit '/users/sign_in'
      fill_in "user_email", with: "ethenry@ucsc.edu"
      fill_in "user_password", with: ENV['ADMIN_PASSWORD']
      page.click_button('Log in')
      expect(page).to have_content("ethenry@ucsc.edu")
      visit '/concern/works/r494vk41k'
      expect(page).to have_content("Review and Approval")
      page.find('span#show-more-metadata a').click
      expect(page).to have_content "Box/Folder"
    end
  end

end


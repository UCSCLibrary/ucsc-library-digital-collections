require 'config/environment'
namespace :hycruz  do 
  task :link_stream => :environment do
    on roles(:app), in: :sequence, wait: 5 do
      print "Linking stream folder..."
      execute "ln -s /dams_derivatives/#{Rails.env} #{current_path}/public/stream"
    end
  end
end
after "deploy:finished","hycruz:link_stream"

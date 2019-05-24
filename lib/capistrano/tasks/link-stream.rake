namespace :hycruz  do 
  task :link_stream do
    on roles(:app), in: :sequence, wait: 5 do
      print "Linking stream folder..."
      print "Rails.env = #{ENV['RAILS_ENV']}"
      execute "ln -s /dams_derivatives/#{ENV['RAILS_ENV']} #{current_path}/public/stream"
    end
  end
end
after "deploy:finished","hycruz:link_stream"

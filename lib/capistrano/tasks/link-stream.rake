namespace :hycruz  do 
  task :link_stream do
    on roles(:app), in: :sequence, wait: 5 do
      set :rails_env, fetch(:stage)
      print "Linking stream folder..."
      print "Rails.env = #{fetch(:stage)}"
      execute "ln -s /dams_derivatives/#{fetch(:stage)} #{current_path}/public/stream"
#      execute "rm #{current_path}/tmp/uploads"
      execute "ln -s /dams_derivatives/#{fetch(:stage)}/tmp/uploads #{current_path}/tmp/uploads"
    end
  end
end
after "deploy:finished","hycruz:link_stream"

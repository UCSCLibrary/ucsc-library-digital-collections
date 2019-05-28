namespace :hycruz  do 
  task :link_stream do
    on roles(:app), in: :sequence, wait: 5 do
      set :rails_env, fetch(:stage)
      print "Linking the stream folder..."
      print "Rails.env = #{fetch(:stage)}"
      execute "ln -s /dams_derivatives/#{fetch(:stage)} #{current_path}/public/stream"
    end
  end
end
after "deploy:finished","hycruz:link_stream"

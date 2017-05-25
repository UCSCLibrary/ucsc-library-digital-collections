namespace :ucsc_sufia_based_dams  do 
  task :stop_resque do
    on roles(:app), in: :sequence, wait: 5 do
      print "Stopping resque-pool (at path #{current_path})..."
      execute "cd '#{current_path}'; ./bin/stop_resque #{fetch(:rails_env)}"
    end
  end
  task :start_resque do
    on roles(:app), in: :sequence, wait: 5 do
      print "Starting resque-pool  (at path #{current_path})..."
      execute "cd '#{current_path}'; ./bin/start_resque #{fetch(:rails_env)}"
    end
  end
end
after "deploy:finished","ucsc_sufia_based_dams:stop_resque"
#after "deploy:finished","ucsc_sufia_based_dams:start_resque"

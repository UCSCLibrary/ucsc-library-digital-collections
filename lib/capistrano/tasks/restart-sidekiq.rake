namespace :ucsc_sufia_based_dams  do 
  task :restart_sidekiq do
    on roles(:app), in: :sequence, wait: 5 do
      print "Restarting tasks..."
      execute "sudo systemctl restart sidekiq"
    end
  end
end
after "deploy","ucsc_sufia_based_dams:restart_sidekiq"

namespace :hycruz  do 

  task :restart_sidekiq do
    on roles(:ingest), in: :sequence, wait: 5 do
#      rails_env = fetch(:stage)
#      service_name = (rails_env === "production") ? "sidekiq" : "sidekiq-staging" 
      print "Restarting task queues..."
#      execute "sudo systemctl restart #{service_name}"
      execute "sudo systemctl restart sidekiq"
      execute "sudo systemctl restart sidekiq-staging"
      print "linking log file..."
      execute "ln -s /srv/ucsc_sufia/shared/log /srv/ucsc_sufia/current/"
    end
  end
end
after "deploy","hycruz:restart_sidekiq"

namespace :hycruz  do 

  task :restart_sidekiq do
    on roles(:ingest), in: :sequence, wait: 5 do
      rails_env = fetch(:stage)
      service_name = (rails_env === "production") ? "sidekiq" : "sidekiq-staging" 
      print "Restarting task queue (#{service_name})..."
      execute "sudo systemctl restart #{service_name}"
    end
  end
end
after "deploy","hycruz:restart_sidekiq"

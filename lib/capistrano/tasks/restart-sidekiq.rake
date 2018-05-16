namespace :hycruz  do 
  task :restart_sidekiq do
    on roles(:ingest), in: :sequence, wait: 5 do
      print "Restarting task queue (sidekiq)..."
      execute "sudo systemctl restart sidekiq"
    end
  end
end
after "deploy","hycruz:restart_sidekiq"

namespace :hycruz  do 
  task :restart_apache do
    on roles(:app), in: :sequence, wait: 5 do
      print "Restarting webserver..."
      execute "sudo systemctl restart httpd"
    end
  end
end
after "deploy","hycruz:restart_apache"

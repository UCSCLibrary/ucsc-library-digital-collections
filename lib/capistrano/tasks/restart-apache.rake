namespace :ucsc_sufia_based_dams  do 
  task :restart_apache do
    on roles(:app), in: :sequence, wait: 5 do
      print "Restarting webserver..."
      execute "sudo systemctl restart httpd"
    end
  end
end
after "deploy","ucsc_sufia_based_dams:restart_apache"

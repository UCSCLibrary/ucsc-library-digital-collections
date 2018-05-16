namespace :hycruz  do 
  task :link_stream do
    on roles(:app), in: :sequence, wait: 5 do
      print "Linking stream folder..."
      execute "ln -s /avalon2sufia/derivatives #{current_path}/public/stream"
    end
  end
end
after "deploy:finished","hycruz:link_stream"

namespace :ucsc_sufia_based_dams  do 
  task :link_stream do
    on roles(:app), in: :sequence, wait: 5 do
      print "Linking stream folder..."
      execute "ln -s /avalontosufia/derivatives #{current_path}/public/stream"
    end
  end
end
after "deploy:finished","ucsc_sufia_based_dams:link_stream"

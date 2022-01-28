namespace :hycruz  do 
  task :link_stream do
    on roles(:app), in: :sequence, wait: 5 do
      set :rails_env, fetch(:stage)
      env = (fetch(:stage).to_s == 'staging') ? "production" : fetch(:stage)
      print "Linking stream folder..."
      execute "ln -s /dams_derivatives/#{env} #{current_path}/public/stream"
    end
    on roles(:ingest,:app), in: :sequence, wait: 5 do
      set :rails_env, fetch(:stage)
      env = (fetch(:stage).to_s == 'staging') ? "production" : fetch(:stage)
      print "creating temp folders if necessary..."
      execute "mkdir -p #{current_path}/tmp"
      execute "mkdir -p /dams_derivatives/tmp/#{env}/imports"
      execute "chown -R hyrax:diginit #{current_path}/tmp/imports"
      print "Linking temp imports folder..."
      execute "rm -f #{current_path}/tmp/imports || true"
      execute "ln -s /dams_derivatives/tmp/#{env}/imports #{current_path}/tmp/imports"
    end
    on roles(:ingest,:app), in: :sequence, wait: 5 do
      set :rails_env, fetch(:stage)
      env = (fetch(:stage).to_s == 'staging') ? "production" : fetch(:stage)
      print "creating temp folders if necessary..."
      execute "mkdir -p #{current_path}/tmp"
      execute "mkdir -p /dams_derivatives/tmp/#{env}/exports"
      execute "chown -R hyrax:diginit #{current_path}/tmp/exports"
      print "Linking temp exports folder..."
      execute "rm -f #{current_path}/tmp/exports || true"
      execute "ln -s /dams_derivatives/tmp/#{env}/exports #{current_path}/tmp/exports"
    end
    on roles(:ingest,:app), in: :sequence, wait: 5 do
      set :rails_env, fetch(:stage)
      env = (fetch(:stage).to_s == 'staging') ? "production" : fetch(:stage)
      print "creating temp folder if necessary..."
      execute "mkdir -p #{current_path}/tmp"
      print "Linking temp upload folder..."
      execute "rm -f #{current_path}/tmp/uploads || true"
      execute "ln -s /dams_derivatives/tmp/#{env}/uploads #{current_path}/tmp/uploads"
    end
  end
end
after "deploy:finished","hycruz:link_stream"

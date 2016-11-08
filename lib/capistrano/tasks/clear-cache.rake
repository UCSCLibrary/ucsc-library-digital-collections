#namespace :ucsc_sufia_based_dams  do 
#  task :clear_cache do
#    on roles(:app), in: :sequence, wait: 5 do
 #     print "Clearing cache"
  #    Rails.cache.clear
#    end
#  end
#end
#after "deploy","ucsc_sufia_based_dams:clear_cache"

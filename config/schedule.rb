# This file defines hycruz cron jobs.
#
set :output, ("/srv/hyrax/log/cron_log.log")

every 1.hour do
  rake "benchmark", :environment => ENV['RAILS_ENV']
end


# Learn more: http://github.com/javan/whenever

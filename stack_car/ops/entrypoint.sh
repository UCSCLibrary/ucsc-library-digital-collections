#!/bin/bash
# set -e
# unset BUNDLE_PATH
# unset BUNDLE_BIN

if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

max_try=${WAIT_MAX_TRY:-12}
wait_seconds=${WAIT_SECONDS:-5}

if [ -f /app/samvera/hyrax-webapp/tmp/pids/server.pid ]; then
  echo "Stopping Rails Server and Removing PID File"
#  ps aux |grep -i [r]ails | awk '{print $2}' | xargs kill -9
  rm -rf /app/samvera/hyrax-webapp/tmp/pids/server.pid
fi

# Uncomment this line to ssh into the container before loading the app
#sleep infinity

#echo "Checking and Installing Ruby Gems"
bundle check || bundle install

echo "Running Database Migration"
bundle exec rake db:migrate

echo "Running Test Database Setup"
# bundle exec rails db:test:prepare

#echo "Seeding Database"
#bundle exec rake db:seed

#echo "Load Workflows"
#bundle exec rake hyrax:workflow:load

#echo "Initialize Default Admin Set"
#bundle exec rake hyrax:default_admin_set:create

# (S.Geezy - This is not working.  Do we need it?)
# echo 'alias repl="cd /srv/hycruz; unset BUNDLE_PATH; unset BUNDLE_BIN; GEM_HOME=/srv/bundle; bundle exec rails c"' >> /home/hycruz/.bashrc
# echo 'alias errors="tail -n 1000 /srv/hyrax/logs/development.log | grep FATAL -A 20 -B 20"' >> /home/hycruz/.bashrc
# echo 'unset BUNDLE_PATH' >> /home/hycruz/.bashrc
# echo 'unset BUNDLE_BIN' >> /home/hycruz/.bashrc

echo "Starting the Rails Server"
bundle exec rails s -b 0.0.0.0

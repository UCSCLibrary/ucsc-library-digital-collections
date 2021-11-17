#!/bin/bash
set -e
unset BUNDLE_PATH
unset BUNDLE_BIN


if [[ "$VERBOSE" = "yes" ]]; then
    set -x
fi

# Uncomment this line to load environment and then
# do nothing, so we can ssh in and change things
#sleep infinity

echo "Checking and Installing Ruby Gems"
bundle check || bundle install

#echo "Load Workflows"
#bundle exec rake hyrax:workflow:load

#echo "Initialize Default Admin Set"
#bundle exec rake hyrax:default_admin_set:create

echo "Stopping Existing sidekiq Tasks"
ps aux |grep -i [s]idekiq | awk '{print $2}' | xargs kill -9 || true

echo "Starting Sidekiq"
exec bundle exec sidekiq -c 1  >> /srv/hycruz/log/sidekiq.log 2>&1

exec "$@"
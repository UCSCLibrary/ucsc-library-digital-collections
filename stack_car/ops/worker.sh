#!/bin/bash

# `/sbin/setuser memcache` runs the given command as the user `memcache`.
# If you omit that part, the command will be run as root.

bundle check || bundle install

bundle exec sidekiq -c 10

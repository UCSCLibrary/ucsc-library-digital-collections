#!/bin/sh
set -e

stack_car/bin/db-wait.sh "$DB_HOST:$DB_PORT"
bundle exec rails db:create
bundle exec rails db:migrate

if [ "$FCREPO_HOST" ]; then
  stack_car/bin/db-wait.sh "$FCREPO_HOST:$FCREPO_PORT"
fi
stack_car/bin/db-wait.sh "$SOLR_HOST:$SOLR_PORT"

bundle exec rails db:seed

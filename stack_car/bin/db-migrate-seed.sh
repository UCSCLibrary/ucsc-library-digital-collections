#!/bin/sh
set -e

bin/db-wait.sh "$DB_HOST:$DB_PORT"
bundle exec rails db:create
bundle exec rails db:migrate

if [ "$FCREPO_HOST" ]; then
  bin/db-wait.sh "$FCREPO_HOST:$FCREPO_PORT"
fi
bin/db-wait.sh "$SOLR_HOST:$SOLR_PORT"

bundle exec rails db:seed

#!/usr/bin/env bash
#
# The wait-for-services script simply polls the given service until it is online
# We wait up to ten minutes for the test webapp to come up, though
# it rarely takes that long unless it needs to reinstall the 
# entire gemset
wait-for-services.sh localhost:3000 -t 600
#
# The other services should definitely be online by now,
# but we wait up to three minutes for each just in case. 
wait-for-services.sh db:3306 -t 180
wait-for-services.sh repo:8080 -t 180
wait-for-services.sh index:8983 -t 180
#
# This command runs all tests in the "spec" folder 
# except the smoke tests (which are run separately)
# and the bulk ops tests which are not yet functional.
# The CI and COVERALLS_REPO_TOKEN variables tell the test suite
# to submit the results to coveralls.io
CI=true COVERALLS_REPO_TOKEN=$COVERALLS_REPO_TOKEN bundle exec rspec spec --exclude-pattern "spec/integration/bulk_ops/*/*_spec.rb, spec/smoke/*_spec.rb"
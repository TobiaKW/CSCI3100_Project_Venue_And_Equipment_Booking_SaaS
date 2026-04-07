#!/usr/bin/env bash
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean

# Run migrations first, then reset database
bin/rails db:migrate
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bin/rails db:reset_prod

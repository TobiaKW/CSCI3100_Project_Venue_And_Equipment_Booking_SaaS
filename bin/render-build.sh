#!/usr/bin/env bash
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean

# Run migrations instead of full schema load to avoid timeouts if DB is large
# but for first time, we use schema:load
# bin/rails db:migrate
bin/rails db:schema:load
bin/rails db:seed

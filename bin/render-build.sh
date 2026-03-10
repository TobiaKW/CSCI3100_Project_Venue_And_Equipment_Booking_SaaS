#!/usr/bin/env bash
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean
bin/rails db:migrate
# bin/rails db:seed # Uncomment if you want to seed on every deploy

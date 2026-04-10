source "https://rubygems.org"

ruby "3.3.10"
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "7.2.3"
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
# Use Import maps to manage JavaScript [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# database gem
gem "pg", "~> 1.5"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# authentication
gem "devise"
# Action Cable
gem "redis", "~> 5.0"
# chartkick
gem "chartkick", "~> 5.2"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", "8.0.4", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  # rspec
  gem 'rspec-rails', '~> 8.0.0'
  # assert_template
  gem "rails-controller-testing"
end

gem "turbo-rails", "~> 2.0"

gem "timecop", "~> 0.9.10"

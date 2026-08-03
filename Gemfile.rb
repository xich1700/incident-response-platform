# Gemfile
source "https://rubygems.org"

ruby "3.4.10"

gem "rails", "~> 8.1.3"
gem "pg", "~> 1.5"
gem "puma", ">= 6.0"
gem "sidekiq", "~> 7.2"
gem "redis", "~> 5.0"
gem "faraday", "~> 2.9"
gem "faraday-retry", "~> 2.2"

group :development, :test do
  gem "rspec-rails", "~> 7.0"
  gem "factory_bot_rails"
  gem "webmock"
  gem "vcr"
  gem "dotenv-rails"
end# frozen_string_literal: true


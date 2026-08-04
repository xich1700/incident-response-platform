source "https://rubygems.org"

ruby "3.4.10"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "pg", "~> 1.5"
gem "puma", ">= 6.0"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "sidekiq", "~> 7.2"
gem "redis", "~> 5.0"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "bootsnap", require: false
gem "kamal", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 8.0"
  gem "factory_bot_rails"
end

group :development do
  gem "web-console"
end

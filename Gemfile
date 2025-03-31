# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Ruby static code analyzer (a.k.a. linter) and code formatter
gem 'rubocop', '~> 1.75', require: false

# Shim to load environment variables from .env into ENV in development
gem 'dotenv', '~> 3.1'

# Powerful, extensible, and feature-packed frontend toolkit
gem 'bootstrap', '~> 5.3'

# Sass is an extension of CSS that adds power and elegance to the basic language
gem 'sassc-rails', '~> 2.1'

group :development do
  # Debugger for Ruby
  gem 'pry-rails', '~> 0.3.11'
end

group :development, :test do
  # Testing framework
  gem 'rspec-rails', '~> 7.1'

  # FactoryBot is a fixtures replacement with a more straightforward syntax
  gem 'factory_bot_rails', '~> 6.4.4'
end

group :test do
  # One-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 6.0'

  # Record your test suite's HTTP interactions and replay them during future test runs
  gem 'vcr', '~> 6.3'

  # Library for stubbing and setting expectations on HTTP requests in Ruby
  gem 'webmock', '~> 3.25'
end

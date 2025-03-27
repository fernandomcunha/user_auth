source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Ruby static code analyzer (a.k.a. linter) and code formatter
gem 'rubocop', '~> 1.75', require: false

group :development do
  # Debugger for Ruby
  gem 'pry-rails', '~> 0.3.11'
end

group :development, :test do
  # Testing framework
  gem 'rspec-rails', '~> 5.0'

  # FactoryBot is a fixtures replacement with a more straightforward syntax
  gem 'factory_bot_rails', '~> 6.4.4'
end

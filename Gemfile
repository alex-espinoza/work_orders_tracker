source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'devise'
gem 'state_machine'
gem 'carrierwave'
gem 'mini_magick'
gem "fog", "~> 1.3.1"
gem 'carrierwave_backgrounder'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'slim'
gem 'cancan'
gem 'configatron'
gem 'google-analytics-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.3.2.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
	gem 'rspec-rails'
	gem 'capybara'
	gem 'launchy'
	gem 'pry-rails'
	gem 'dotenv-rails'
end

group :test do
	gem 'factory_girl_rails'
	gem "shoulda-matchers"
	gem "rspec-sidekiq"
end

group :development do
	gem 'sextant'
	gem 'better_errors'
	gem 'binding_of_caller'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

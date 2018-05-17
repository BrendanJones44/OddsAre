source 'https://rubygems.org'

ruby '2.3.4'

gem 'pg'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.4'
# Use sqlite3 as the database for Active Record
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'bootstrap', '~> 4.0.0.alpha6'

gem 'react-rails'

gem 'rubocop', '~> 0.56.0', require: false

gem 'language_filter'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'devise'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 5.1.0'
gem 'has_friendship'
gem 'jquery-turbolinks'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
group :test do
  gem 'cucumber-rails', require: false
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner', '~> 1.5'
  gem 'faker', '~> 1.8.7'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'simplecov', require: false
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'capybara', '~> 2.5'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'rack-mini-profiler', require: false
  gem 'rspec-rails', '~> 3.4'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

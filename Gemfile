source 'https://rubygems.org'

ruby '2.3.4'
gem 'pg'
gem 'pry'
gem 'rails', '~> 5.0.4'
gem 'puma', '~> 3.0'

gem 'ransack' # for searching on web

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'bootstrap'

gem 'rack-cors', require: 'rack/cors'
gem 'react-rails'

gem 'rubocop', '~> 0.56.0', require: false

gem 'language_filter'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'devise'
gem 'font-awesome-rails'
gem 'friendly_id', '~> 5.1.0'
gem 'has_friendship'
gem 'jquery-turbolinks'

group :test, :staging do
  gem 'database_cleaner', '~> 1.5'
  gem 'faker', '~> 1.8.7'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'simplecov', require: false
end

group :development, :test, :staging do
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

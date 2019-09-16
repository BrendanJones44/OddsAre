require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OddsAreApp
  class Application < Rails::Application
    if Rails.env == 'development'
      config.web_console.whiny_requests = false
    end
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
           headers: :any,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :options, :delete, :put]
      end
    end
    #config.web_console.whitelisted_ips = '172.19.0.1'    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

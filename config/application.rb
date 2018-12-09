require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OddsAreApp
  class Application < Rails::Application
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: %w(Authorization),
          methods: :any,
          expose: %w(Authorization)
      end
    end
    config.to_prepare do
      DeviseController.respond_to :html, :json
    end

    #config.web_console.whitelisted_ips = '172.19.0.1'    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

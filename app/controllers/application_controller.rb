# Top level controller for Rails
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end

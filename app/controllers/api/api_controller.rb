# frozen_string_literal: true

class Api::ApiController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  # Auth helpers here
end

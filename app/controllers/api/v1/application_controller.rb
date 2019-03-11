# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::Base
      include DeviseTokenAuth::Concerns::SetUserByToken
    end
  end
end

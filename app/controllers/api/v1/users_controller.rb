# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def metadata
    @notifications = current_user
                    .notifications.needs_action.order(created_at: :desc)
    render json: @notifications
  end
end

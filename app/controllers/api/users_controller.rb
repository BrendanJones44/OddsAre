# frozen_string_literal: true

class Api::UsersController < Api::ApiController
  def authenticate
    user = User.find_for_authentication(email: params[:user][:email])

    authenticated = user.valid_password?(params[:user][:password])
    resp_message = authenticated ? user.auth_token : 'wrong password'

    render json: resp_message
  end

  def metadata
    @notifications = current_user
                     .notifications.needs_action.order(created_at: :desc)
    render json: @notifications
  end
end

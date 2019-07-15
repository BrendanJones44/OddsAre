# frozen_string_literal: true

class Api::UsersController < Api::ApiController
  def authenticate
    user = User.find_for_authentication(email: params[:email])

    if user
      authenticated = user.valid_password?(params[:password])
      if authenticated
        resp_message = 'authenticated'
        data_hash = {
          notifications: user.notification_feed,
          friends: user.filtered_friends
        }
        response.set_header('auth_token', user.new_auth_token)
      end
    else
      resp_message = 'no user found'
      data_hash = {}
    end

    render json: {
      message: resp_message,
      data: data_hash
    }
  end

  def metadata
    @notifications = current_user
                     .notifications.needs_action.order(created_at: :desc)
    render json: @notifications
  end
end

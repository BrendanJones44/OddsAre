# frozen_string_literal: true

class Api::UsersController < Api::ApiController
  def authenticate_and_metadata
    user = User.find_for_authentication(email: params[:email])

    if user
      authenticated = user.valid_password?(params[:password])
      if authenticated
        response.set_header('auth_token', user.new_auth_token)
        @notifications = user.notification_feed
        @friends = user.filtered_friends
        @user_id = user.id
        render 'authenticated_with_metadata'
      else
        render 'failed_authentication', status: :unauthorized
      end
    else
      @invalid_email = params[:email]
      render 'not_found_by_email', status: :not_found
    end
  end

  def metadata
    @notifications = current_user
                     .notifications.needs_action.order(created_at: :desc)
    render json: @notifications
  end
end

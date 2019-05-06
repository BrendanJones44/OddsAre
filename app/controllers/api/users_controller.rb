# frozen_string_literal: true

class Api::UsersController < Api::ApiController
  def authenticate
    permitted = params.require(:user).permit(:email, :password)
    user = User.find_for_authentication(email: params[:user][:email])

    resp = user.valid_password?(params[:user][:password]) ? user.auth_uuid : "wrong password"
    render json: resp
  end

  def metadata
    @notifications = current_user
                     .notifications.needs_action.order(created_at: :desc)
    render json: @notifications
  end
end

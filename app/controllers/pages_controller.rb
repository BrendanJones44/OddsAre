# Controller created for viewing pages through Rails convention
class PagesController < ApplicationController
  def index
    return unless current_user
    @user = current_user
    @notifications = @user.notifications.needs_action.order(created_at: :desc)
    render 'users/profile_view'
  end
end

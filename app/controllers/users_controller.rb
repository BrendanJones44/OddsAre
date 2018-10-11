# Controller for viewing users
class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.friendly.find(params[:friendly])
    if current_user == @user
      @notifcations = @user.notifications.needs_action
      render 'users/profile_view'
    else
      if params.key?(:notification_id)
        n = Notification.find(params[:notification_id])
        if n.user_can_update(current_user)
          n.update(acted_upon_at: Time.zone.now)
        end
      end
      render 'users/show'
    end
  end

  def all
    @view_type = 'All Users'
    @users = User
             .where
             .not(id: current_user.id)
             .sort_by(&:num_completed_odds_ares)
             .reverse
  end

  def friends
    @view_type = 'Your Friends'
    @users = current_user.friends
    render 'users/all'
  end

  def search
    @users = User
             .ransack(first_name_or_last_name_cont: params[:q])
             .result(distinct: true)
    respond_to do |format|
      format.html {}
      format.json do
        @users = @users.limit(5)
      end
    end
  end
end

# Controller for viewing users
class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.friendly.find(params[:friendly])
    if current_user == @user
      @notifcations = @user.notifications.needs_action
      render 'users/profile_view'
    else
      render 'users/show'
    end
  end

  def all
    @view_type = 'All Users'
    @users = User.where.not(id: current_user.id).order(:first_name)
  end

  def friends
    @view_type = 'Your Friends'
    @users = current_user.friends
    render 'users/all'
  end
end

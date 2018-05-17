# Controller for viewing users
class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.friendly.find(params[:friendly])
  end

  def all
    @view_type = 'All Users'
    @users = User.where.not(id: current_user.id)
  end

  def friends
    @view_type = 'Your Friends'
    @users = current_user.friends
    render 'users/all'
  end
end

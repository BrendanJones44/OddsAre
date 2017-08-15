class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:friendly])
  end

  def all
    @users = User.where.not(id: current_user.id)
  end
end

class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:friendly])
  end
end

class FriendRequestsController < ApplicationController
  def show
    @friend_request = FriendRequest.find(params[:id])
    if current_user.id == @friend_request.acting_user.id
      redirect_to user_show_path(@friend_request.targeting_user)
    else
      redirect_to user_path(@friend_request.acting_user)
    end
  end
end

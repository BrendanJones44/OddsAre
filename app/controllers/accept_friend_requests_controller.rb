class AcceptFriendRequestsController < ApplicationController
  before_action :authenticate_user!
  def show
    @accepted_friend_request = AcceptFriendRequest.find(params[:id])
    if @accepted_friend_request.acted_upon_at.nil?
      @accepted_friend_request.update(acted_upon_at: Time.zone.now)
    end
    if current_user.id == @accepted_friend_request.acting_user_id
      redirect_to user_path(@accepted_friend_request.targeting_user)
    else
      redirect_to user_path(@accepted_friend_request.acting_user_id)
    end
  end
end

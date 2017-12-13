# This controller is used to process the flow of data between
# clicking a friend request notifcation and viewing the requester's profile

# TODO: Rename class
class AcceptFriendRequestsController < ApplicationController
  before_action :authenticate_user!
  def show
    @accepted_friend_request = AcceptFriendRequest.find(params[:id])

    # First time viewing friend request should update the timestamp
    # which marks the notifcation as clicked on

    # TODO: Add check to make sure it's the user's notification before updating
    if @accepted_friend_request.acted_upon_at.nil?
      @accepted_friend_request.update(acted_upon_at: Time.zone.now)
    end

    # View the friend request's profile

    # TODO: Maybe fix this up a bit?
    if current_user.id == @accepted_friend_request.acting_user_id
      redirect_to user_path(@accepted_friend_request.targeting_user)
    else
      redirect_to user_path(@accepted_friend_request.acting_user_id)
    end
  end
end

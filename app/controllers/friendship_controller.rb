class FriendshipController < ApplicationController
  def send_request
    @recipient = User.find(params[:user_id])
    current_user.friend_request(@recipient)
    @friend_request = FriendRequest.create(target_user_id: @recipient.id, acting_user_id: current_user.id)
    Notification.create(recipient: @recipient, actor: current_user, action: "sent you a friend request", notifiable: @friend_request)
    redirect_to '/users/all'
  end

  def accept_friend_request
    @actor = User.find_by_user_name(params[:user_name])
    @friend_request = FriendRequest.where(target_user_id: current_user.id, acting_user_id: @actor.id).first
    @friend_request.update(acted_upon_at: Time.zone.now)
    current_user.accept_request(@actor)
    Notification.create(recipient: @actor, actor: current_user, action: "accepted your friend request", notifiable: current_user)
    redirect_to '/friendship/show_friend_requests'
  end

  def show_friend_requests
    @friend_requests = current_user.requested_friends
  end

end

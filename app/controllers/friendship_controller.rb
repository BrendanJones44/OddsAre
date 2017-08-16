class FriendshipController < ApplicationController
  def send_request
    @recipient = User.find(params[:user_id])
    current_user.friend_request(@recipient)
    Notification.create(recipient: @recipient, actor: current_user, action: "Sent You A Notification", notifiable: @recipient)
    redirect_to '/users/all'
  end

  def accept_friend_request
    current_user.accept_request(User.find_by_user_name(params[:user_name]))
    redirect_to 'friendship/show_friend_requests'
  end

  def show_friend_requests
    @friend_requests = current_user.requested_friends
  end

end

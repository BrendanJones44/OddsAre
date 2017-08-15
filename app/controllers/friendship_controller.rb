class FriendshipController < ApplicationController
  def send_request
    current_user.friend_request(User.find_by_user_name(params[:user_name]))
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

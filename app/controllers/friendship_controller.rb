# Controller for handling and viewing user friendships
# Makes use of the FriendlyId gem that users extend
class FriendshipController < ApplicationController
  before_action :authenticate_user!

  # POST /friendship/send_friend_request
  def send_friend_request
    recipient = User.find(params.require(:user_id))
    if current_user.can_send_friend_request_to recipient
      current_user.friend_request(recipient)
      Notification.create(recipient: recipient,
                          actor: current_user,
                          action: 'sent you a friend request',
                          notifiable: current_user,
                          dismiss_type: 'on_click')
    end
    redirect_back(fallback_location: root_path)
  end

  # POST /friendship/accept_friend_request
  def accept_friend_request
    actor = User.find(params.require(:user_id))
    if current_user.can_accept_friend_request_from actor
      current_user.accept_request(actor)
      n = Notification.where(notifiable: actor,
                             actor: actor,
                             recipient: current_user).first
      n&.update(acted_upon_at: Time.zone.now)
      Notification.create(recipient: actor,
                          actor: current_user,
                          action: 'accepted your friend request',
                          notifiable: current_user,
                          dismiss_type: 'on_click')
    end
    redirect_back(fallback_location: root_path)
  end

  # GET /friendship/show_friend_requests
  def show_friend_requests
    @friend_requests = current_user.requested_friends
  end
end

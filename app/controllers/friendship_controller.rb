# Controller for handling and viewing user friendships
# Makes use of the FriendlyId gem that users extend
class FriendshipController < ApplicationController
  before_action :authenticate_user!

  # POST /friendship/send_friend_request
  def send_friend_request
    recipient = User.find(params.require(:user_id))
    unless recipient.blank?
      if current_user.friends.include? recipient
        raise Exception, 'Friendship already exists'
      end
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
    unless actor.blank?
      if current_user.friends.include? actor
        raise Exception, 'Friendship already exists'
      end
      if actor.pending_friends.include? current_user
        current_user.accept_request(actor)
        Notification.create(recipient: actor,
                            actor: current_user,
                            action: 'accepted your friend request',
                            notifiable: current_user,
                            dismiss_type: 'on_click')
      else
        raise Exception, 'No friend request exists to accept'
      end
    end
    redirect_back(fallback_location: root_path)
  end

  # GET /friendship/show_friend_requests
  def show_friend_requests
    @friend_requests = current_user.requested_friends
  end
end

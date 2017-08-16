class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(recipient: current_user).unread
  end
end

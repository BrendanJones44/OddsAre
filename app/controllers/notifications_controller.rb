class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(recipient: current_user).unread
    #@notifications = Notification.where(recipient: current_user).needs_action
  end

  def mark_as_read
    @notifications = Notification.where(recipient: current_user).unread
    @notifications.update_all(read_at: Time.zone.now)
    render json: {success: true}
  end

#  def mark_as_clicked
#    @notifc = Notifcation.where(recipient: current_user).unclicked
#    @notification.update_all(clicked_at: Time.zone.now)
#    render json: {success: true}
#  end
end

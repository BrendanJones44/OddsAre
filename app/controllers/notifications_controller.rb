class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    #@notifications = Notification.where(recipient: current_user).unread
    pre_notifications = Notification.where(recipient: current_user)
    array_build = []
    if pre_notifications == []
      @notifications = pre_notifications
    else
      pre_notifications.each do |n|
        if n.notifiable.acted_upon_at.nil?
          array_build.push(n)
        end
      end
      @notifications = array_build
    end
  end

  def mark_as_read
    @notifications = Notification.where(recipient: current_user).unread
    @notifications.update_all(read_at: Time.zone.now)
    render json: {success: true}
  end

end

class NotificationsController < ApplicationController
  def mark_as_read
    notification = Notification.find(params[:id])
    notification.update(acted_upon_at: Time.zone.now)
  end
end

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  # POST /notifications/:id/mark_as_read
  def mark_as_read
    notification = Notification.find(params.require(:id))
    if notification.user_can_update(current_user)
      notification.update(acted_upon_at: Time.zone.now)
    else
      return head(:forbidden)
    end
  end
end

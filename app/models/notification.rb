class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :needs_action, -> {where(acted_upon_at: nil)}

  def to_s
    actor.first_name + " " + actor.last_name + " " + "(@" + actor.user_name + ") " + action
  end
end

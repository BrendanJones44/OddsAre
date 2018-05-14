class Notification < ApplicationRecord
  enum dismiss_type: [:on_click]
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :needs_action, -> { where(acted_upon_at: nil) }

  def user_can_update(user)
    recipient_id? && user == recipient
  end

  def to_s
    actor.first_name + ' ' + actor.last_name + ' ' + action
  end
end

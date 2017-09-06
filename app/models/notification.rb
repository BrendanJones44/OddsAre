class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> {where(read_at: nil)}
  scope :unclicked, -> {where(clicked_at: nil)}
  #scope :needs_action, -> {where(notifiable: {acted_upon_at: nil})}

  def needs_action
    notifiable.acted_upon_at.nil?
  end
end

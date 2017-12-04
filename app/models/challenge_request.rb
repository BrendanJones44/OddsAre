class ChallengeRequest < ApplicationRecord
  has_one :challenge_response
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  scope :unread, -> {where(read_at: nil)}
  validates_presence_of :action, :message => 'You must say what the odds are is'
  has_one :notification, as: :notifiable

end

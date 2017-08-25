class ChallengeRequest < ApplicationRecord
  has_one :challenge_response
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  scope :unread, -> {where(read_at: nil)}
  
end

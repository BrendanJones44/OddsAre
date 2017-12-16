class ChallengeRequest < ApplicationRecord
  ### Associations ###
  has_one :challenge_response
  has_one :notification, as: :notifiable
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :actor, class_name: "User", foreign_key: "actor_id"

  ### Validations ###
  validates_presence_of :action, :message => 'You must say what the odds are is'

  ### Helper methods ###
  scope :unread, -> {where(read_at: nil)}

end

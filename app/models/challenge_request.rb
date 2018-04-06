class ChallengeRequest < ApplicationRecord
  ### Associations ###
  has_one :notification, as: :notifiable
  
  ### Validations ###
  validates_presence_of :action, :message => 'You must say what the odds are is'

  ### Helper methods ###
  scope :unread, -> {where(read_at: nil)}

end

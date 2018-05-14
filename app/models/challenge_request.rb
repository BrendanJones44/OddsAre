class ChallengeRequest < ApplicationRecord
  ### Associations ###
  has_one :notification, as: :notifiable
  belongs_to :odds_are

  ### Validations ###
  validates_presence_of :action, message: 'You must say what the odds are is'
end

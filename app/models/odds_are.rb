class OddsAre < ApplicationRecord
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :initiator, class_name: 'User', foreign_key: 'initiator_id'
  has_one :challenge_request
  has_one :challenge_response
  has_one :challenge_finalization
  has_one :task
  has_one :notification, as: :notifiable
end

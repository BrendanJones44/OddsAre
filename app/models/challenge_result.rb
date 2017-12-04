class ChallengeResult < ApplicationRecord
  has_one :notification, as: :notifiable
end

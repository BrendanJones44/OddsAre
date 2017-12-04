class AcceptFriendRequest < ApplicationRecord
  has_one :notification, as: :notifiable
end

class FriendRequest < ApplicationRecord
  belongs_to :targeting_user, class_name: "User"
  belongs_to :acting_user, class_name: "User"
end

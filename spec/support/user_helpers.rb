module UserHelpers
  def get_user_with_friends
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user
    user_a.friend_request(user_b)
    user_b.accept_request(user_a)
    user_a
  end

  def get_user_with_friend_request
    user_a = FactoryGirl.create :user
    user_b = FactoryGirl.create :user
    user_a.friend_request(user_b)
    user_b
  end
end

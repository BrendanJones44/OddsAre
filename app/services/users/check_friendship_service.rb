# Throw an exception if the two users are not friends
class CheckFriendshipService
  def initialize(user, other_user)
    @user = user
    @other_user = other_user
  end

  def call
    unless @user.friends.include? @other_user
      raise Exception,
            'You must be friends with the recpient ' \
            'to odds are them'
    end
  end
end

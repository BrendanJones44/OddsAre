require 'rails_helper'
require './app/services/users/check_friendship_service'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

describe CheckFriendshipService do
  describe '#call' do
    context 'with both users as friends' do
      let(:user_with_friend) { user_with_friends }
      it 'does not raise an exception' do
        expect do
          CheckFriendshipService.new(user_with_friend,
                                     user_with_friend.friends.first).call
        end.to_not raise_error
      end
    end

    context 'where they are not friends' do
      let(:user_without_friends) { build(:user) }
      let(:other_user) { build(:user) }
      it 'raises an exception' do
        expect do
          CheckFriendshipService.new(user_without_friends, other_user).call
        end.to raise_error 'You must be friends with the recpient to odds ' \
                           'are them'
      end
    end
  end
end

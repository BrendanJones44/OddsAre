require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe User, type: :model do
  it "has a valid factory" do
    user = build(:user)
    expect(user).to be_valid
  end

  describe User do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:user_name) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    describe "#full_name" do
      it "returns the full name" do
        user = build(:user)
        user.update_attribute(:first_name, "Bob")
        user.update_attribute(:last_name, "Mill")
        expect(user.full_name).to eql("Bob Mill")
      end
    end

    describe "#has_friends" do
      context "user has no friends" do
        user_a = FactoryGirl.create :user
        it { expect( user_a.has_friends ).to be false }
      end

      context "user has friends" do
        before(:each) do
          user_with-friends = get_user_with_friends()
          it { expect( user_with_friends.has_friends ).to be true }
        end
      end
    end

    describe "#has_friend_requests" do
      context "user has no friend requests" do
        user_without_friend_requests = FactoryGirl.create :user
        it { expect( user_without_friend_requests.has_friend_requests ).to be false }
      end

      context "user has a friend request" do
        before(:each) do
          user_with_friend_request = get_user_with_friend_request()
          it { expect( user_with_friend_request.has_friend_requests ).to be true }
        end
      end
    end

  end
end

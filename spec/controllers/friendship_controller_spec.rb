require 'rails_helper'
require './spec/support/user_helpers'

RSpec.describe FriendshipController, type: :controller do
  describe "POST #send_friend_request" do
    let(:user) { FactoryGirl.create(:user) }

    context "anonymous user" do
      it "should be redirected to signin" do
        post :send_friend_request
        expect( response ).to redirect_to( new_user_session_path )
      end
    end

    context "authenticated user" do
      before do
        sign_in user
      end

      context "requests with no parameters" do
        it "raises an exception" do
          expect{ post(:send_friend_request, {}) }.to raise_error ActionController::ParameterMissing
        end
      end

      context "requests with non-existent user_id" do
        it "raises an exception" do
          expect{ post :send_friend_request, params: { user_id: 10000 } }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context "requests with existing alternate user" do
        let(:other_user) { FactoryGirl.create :user }

        context "and requesting user is already friends with other user" do
          before do
            user.friend_request(other_user)
            other_user.accept_request(user)
          end

          it "should respond with an error" do
            expect{ post :send_friend_request, params: { user_id: other_user.id }}. to raise_error 'Friendship already exists'
          end
        end

        context "and requesting user is not friends with other user" do
          before do
            request.env["HTTP_REFERER"] = "base_path"
            post :send_friend_request, params: { user_id: other_user.id }
          end

          it "should redirect user back" do
            expect( response ).to redirect_to "base_path"
          end

          it "should have updated user's friend requests" do
            expect(other_user.requested_friends.size).to eql 1
          end

          it "should have sent the other user a notification" do
            expect(other_user.notifications.size).to eql 1
          end

        end
      end
    end
  end
end

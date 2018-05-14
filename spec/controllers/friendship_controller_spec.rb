require 'rails_helper'
require './spec/support/user_helpers'

RSpec.describe FriendshipController, type: :controller do
  describe 'POST #send_friend_request' do
    let(:user) { FactoryGirl.create(:user) }

    context 'anonymous user' do
      it 'should be redirected to signin' do
        post :send_friend_request
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      before do
        sign_in user
      end

      context 'requests with no parameters' do
        it 'raises an exception' do
          expect { post(:send_friend_request, {}) }.to raise_error ActionController::ParameterMissing
        end
      end

      context 'requests with non-existent user_id' do
        it 'raises an exception' do
          expect { post :send_friend_request, params: { user_id: 10_000 } }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'requests with existing alternate user' do
        let(:other_user) { FactoryGirl.create :user }

        context 'and requesting user is already friends with other user' do
          before do
            user.friend_request(other_user)
            other_user.accept_request(user)
          end

          it 'should respond with an error' do
            expect { post :send_friend_request, params: { user_id: other_user.id } }. to raise_error 'Friendship already exists'
          end
        end

        context 'and requesting user is not friends with other user' do
          before do
            request.env['HTTP_REFERER'] = 'base_path'
            post :send_friend_request, params: { user_id: other_user.id }
          end

          it 'should redirect user back' do
            expect(response).to redirect_to 'base_path'
          end

          it 'should have updated users friend requests' do
            expect(other_user.requested_friends.size).to eql 1
          end

          it 'should have sent the other user a notification' do
            expect(other_user.notifications.size).to eql 1
          end
        end
      end
    end
  end

  describe 'POST #accept_friend_request' do
    let(:user) { FactoryGirl.create(:user) }

    context 'anonymous user' do
      it 'should be redirected to signin' do
        post :accept_friend_request
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      before do
        sign_in user
      end

      context 'requests with no parameters' do
        it 'raises an exception' do
          expect { post(:accept_friend_request, {}) }.to raise_error ActionController::ParameterMissing
        end
      end

      context 'requests with non-existent user_id' do
        it 'raises an exception' do
          expect { post :send_friend_request, params: { user_id: 10_000 } }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'requests with existing alternate user' do
        let(:other_user) { FactoryGirl.create :user }

        context 'and accepting user did not receive a friend request from other user' do
          it 'should respond with an error' do
            expect { post :accept_friend_request, params: { user_id: other_user.id } }. to raise_error 'No friend request exists to accept'
          end
        end

        context 'and accepting user is already friends with other user' do
          before do
            user.friend_request(other_user)
            other_user.accept_request(user)
          end

          it 'should respond with an error' do
            expect { post :accept_friend_request, params: { user_id: other_user.id } }. to raise_error 'Friendship already exists'
          end
        end

        context 'and accepting user sent the user a friend request' do
          before do
            request.env['HTTP_REFERER'] = 'base_path'
            other_user.friend_request(user)
            post :accept_friend_request, params: { user_id: other_user.id }
          end

          it 'should redirect user back' do
            expect(response).to redirect_to 'base_path'
          end

          it 'should have updated other users friend requests' do
            expect(other_user.requested_friends.size).to eql 0
          end

          it 'should have sent the other user a notification' do
            expect(other_user.notifications.size).to eql 1
          end

          it 'should recognize other_user as a friend' do
            expect(user.friends.include?(other_user)). to eql true
          end

          it 'should recognize user as other_users friend' do
            expect(other_user.friends.include?(user)) . to eql true
          end
        end
      end
    end
  end

  describe 'GET #show_friend_requests' do
    let(:user) { FactoryGirl.create(:user) }

    context 'anonymous user' do
      it 'should be redirected to signin' do
        get :show_friend_requests
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      before do
        sign_in user
      end

      context 'requests without having any friend requests' do
        it 'should return an empty array' do
          get :show_friend_requests
          expect(assigns(:friend_requests)).to eq([])
        end
      end

      context 'requests with a friend request' do
        let(:other_user) { FactoryGirl.create :user }

        before do
          other_user.friend_request(user)
        end

        it 'should return have a friend request' do
          get :show_friend_requests
          expect(assigns(:friend_requests).size).to eq(1)
        end
      end
    end
  end
end

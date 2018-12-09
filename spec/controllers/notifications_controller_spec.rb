require 'rails_helper'
require './spec/support/user_helpers'
require 'devise/jwt/test_helpers'

RSpec.describe NotificationsController, type: :controller do
  describe 'POST #mark_as_read' do
    let(:user) { FactoryGirl.create(:user) }
    context 'anonymous user' do
      it 'should be redirected to signin' do
        post :mark_as_read, params: { id: 1 }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      before do
        sign_in user
      end

      context 'and notification does not exist' do
        it 'should throw an exception' do
          expect do
            post :mark_as_read,
                 params: { id: 10_000 }
          end .to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'and notification recpient is not user' do
        let(:notification) { FactoryGirl.create(:notification) }
        before do
          notification.recipient_id = 4
          post :mark_as_read, params: { id: notification.id }
        end
        it 'should throw an exception' do
          expect(response).to have_http_status(:forbidden)
        end
        it 'should not have marked the notification as read' do
          expect(notification.read_at).to eql nil
        end
      end
      context 'and notification recpient is user' do
        let(:notification) { FactoryGirl.create(:notification) }
        before do
          notification.update(recipient_id: user.id)
          post :mark_as_read, params: { id: notification.id }
        end
        it 'should respond with ok' do
          expect(response).to have_http_status(204)
        end
        it 'should have updated the notificatin as read' do
          expect(notification.reload.acted_upon_at?). to eql true
        end
      end
    end
  end

  describe 'GET #new' do
    context 'authenticated user' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        get :new
      end

      it 'should respond with found' do
        expect(response).to have_http_status(200)
      end

      it 'should respond with the users notifications' do
        parsed_body = JSON.parse(response.body)
        expect(parsed_body).to match_array(user.notifications.needs_action)
      end
    end
  end
end

require 'rails_helper'
require './spec/support/user_helpers'

RSpec.describe NotificationsController, type: :controller do
  describe "POST #mark_as_read" do
    let(:user) { FactoryGirl.create(:user) }
    context "anonymous user" do
      it "should be redirected to signin" do
        post :mark_as_read, params: { id: 1 }
        expect( response ).to redirect_to( new_user_session_path )
      end
    end

    context "authenticated user" do
      before do
        sign_in user
      end

      context "and notification doesn't exist" do
        it "should throw an exception" do
          expect{ post :mark_as_read, params: { id: 10000 } }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context "and notification's recpient isn't user" do
        let(:notification) { FactoryGirl.create(:notification) }
        before do
          notification.recipient_id = 4
          post :mark_as_read, params: { id: notification.id }
        end
        it "should throw an exception" do
          expect(response).to have_http_status(:forbidden)
        end
        it "should not have marked the notification as read" do
          expect(notification.read_at).to eql nil
        end
      end
      context "and notification's recpient is user" do
        let(:notification) { FactoryGirl.create(:notification) }
        before do
          notification.update(recipient_id: user.id)
          post :mark_as_read, params: { id: notification.id }
        end
        it "should respond with ok" do
          expect(response).to have_http_status(204)
        end
        it "should have updated the notificatin as read" do
          expect(notification.reload.acted_upon_at?). to eql true
        end
      end
    end
  end
end

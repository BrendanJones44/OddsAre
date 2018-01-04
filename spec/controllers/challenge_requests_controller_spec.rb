require 'rails_helper'
RSpec.describe ChallengeRequestsController, type: :controller do
  describe "GET #new" do
    context "anonymous user" do
      it "should be redirected to signin" do
        get :new
        expect( response ).to redirect_to( new_user_session_path )
      end
    end

    context "authenticated user without friends" do
      before(:each) do
        user = FactoryGirl.create :user
        sign_in user
        get :new
      end
      it "should tell the user they need friends " do
        expect( response ).to render_template( "pages/need_friends" )
      end
    end

    context "authenticated user with friends" do
      before(:each) do
        user_a = FactoryGirl.create :user
        sign_in user_a
        user_b = FactoryGirl.create :user
        user_a.friend_request(user_b)
        user_b.accept_request(user_a)
        get :new
      end
      it "should allow the user to view the new request page" do
        expect(response ).to render_template( "challenge_requests/new" )
      end
    end
  end
end

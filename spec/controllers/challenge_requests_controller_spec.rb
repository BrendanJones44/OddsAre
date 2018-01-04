require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

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
        user_with_friends = get_user_with_friends()
        sign_in user_with_friends
        get :new
      end
      it "should allow the user to view the new request page" do
        expect(response ).to render_template( "challenge_requests/new" )
      end
    end
  end
end

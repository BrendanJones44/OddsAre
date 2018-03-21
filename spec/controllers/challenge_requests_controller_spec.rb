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

  describe "POST #create" do
    let(:user) { FactoryGirl.create(:user) }
    context "anonymous user" do
      it "should be redirected to signin" do
        post :create
        expect( response ).to redirect_to( new_user_session_path )
      end
    end
    context "authenticated user" do
      before do
        sign_in user
      end

      context "requests with no parameters" do
        it "should require parameters" do
          expect{
            post :create, params: {}
          }.to raise_error ActionController::ParameterMissing
        end
      end

      context "with empty challenge request" do
        let(:empty_challenge_request) { ChallengeRequest.new() }
        it "throws an error" do
          expect{
            post :create, params: { challenge_request: empty_challenge_request }
          }.to raise_error ActionController::ParameterMissing
        end
      end

      context "with valid challenge request" do
        before do

        end
        let(:challenge_request) { build(:challenge_request) }

        context "without any recipient" do
          it "throws an error" do
            expect{
              post :create, params: { challenge_request: challenge_request }
            }.to raise_error ActionController::ParameterMissing
          end
        end

        context "with non-exisistent recpient id" do
          it "throws an error" do
            puts("BRENDAN")
            puts(challenge_request.action)
            expect{
              post :create, :params => {
                :challenge_request => { :action => "My Widget"},
                :recipient_id => 10000
              }
            }.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end


    end
  end
end

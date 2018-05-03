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

      context "requests with empty challenge request" do
        let(:empty_challenge_request) { ChallengeRequest.new() }
        it "throws an error" do
          expect{
            post :create, params: { challenge_request: empty_challenge_request }
          }.to raise_error ActionController::ParameterMissing
        end
      end

      context "with valid challenge request" do
        let(:valid_challenge_request) {
          FactoryGirl.attributes_for(:challenge_request)
        }

        context "without any recipient" do
          it "throws an error" do
            expect{
              post :create, params: { challenge_request:
                 valid_challenge_request
              }
            }.to raise_error ActionController::ParameterMissing
          end
        end

        context "with non-exisistent recpient id" do
          it "throws an error" do
            expect{
              post :create, :params => {
                :challenge_request => valid_challenge_request,
                :recipient_id => 10000
              }
            }.to raise_error ActiveRecord::RecordNotFound
          end
        end

        context "with exisiting recpient id" do
          let(:user_receiving_odds_are) { FactoryGirl.create(:user) }
          it "requires users to be friends" do
            expect{
              post :create, :params => {
                :challenge_request => valid_challenge_request,
                :recipient_id => user_receiving_odds_are.id
              }
            }.to raise_error 'You must be friends with the recpient to odds are them'
          end

          context "and the users are friends" do
            before do
              request.env["HTTP_REFERER"] = "base_path"
              user.friend_request(user_receiving_odds_are)
              user_receiving_odds_are.accept_request(user)
              post :create, :params => {
                :challenge_request => valid_challenge_request,
                :recipient_id => user_receiving_odds_are.id
              }
            end

            it "should create a challenge request object" do
              expect(ChallengeRequest.all.size). to eql 1
            end

            it "should create an odds are object" do
              expect(OddsAre.all.size).to eql 1
            end

            it "should relate the created odds are to the created challenge request" do
              expect(OddsAre.first.challenge_request).to eql (ChallengeRequest.first)
            end

            it "should create a notification for receiving user" do
              expect(user_receiving_odds_are.notifications.size).to eql 1
            end

            it "should update the challenger's sent odds ares" do
              expect(user.sent_odds_ares.size).to eql 1
            end

            it "should update the receiver's received odds ares" do
              expect(user_receiving_odds_are.received_odds_ares.size).to eql 1
            end

            it "should redirect user back" do
              expect( response ).to redirect_to( challenge_requests_show_current_path(show_friends: "active") )
            end
          end
        end
      end

      context "with invalid challenge request" do

        let(:user_receiving_odds_are) { FactoryGirl.create(:user) }
        let(:invalid_challenge_request) {
          FactoryGirl.attributes_for(:challenge_request, :action => nil)
        }

        before do
          user.friend_request(user_receiving_odds_are)
          user_receiving_odds_are.accept_request(user)
          post :create, :params => {
            :challenge_request => invalid_challenge_request,
            :recipient_id => user_receiving_odds_are.id
          }
        end

        it "should redirect user to challenge request form" do
          expect( response ).to render_template( "challenge_requests/new/" )
        end
      end
    end
  end
end

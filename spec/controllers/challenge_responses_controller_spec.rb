require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe ChallengeResponsesController, type: :controller do
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

      context "requests with empty challenge response" do
        let(:empty_challenge_response) { ChallengeResponse.new() }
        it "throws an error" do
          expect{
            post :create, params: {
              challenge_response: empty_challenge_response
             }
          }.to raise_error ActionController::ParameterMissing
        end
      end

      context "requests with non-existent odds are" do
        let(:invalid_challenge_response) {
           FactoryGirl.attributes_for(:challenge_response)
         }
        it "throws an error" do
          expect{
            post :create, params: { odds_are_id: 1,
              :challenge_response => invalid_challenge_response }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context "requests where the odds are recipient isn't the user" do
        let(:other_user) { FactoryGirl.create(:user) }
        let(:non_associated_odds_are) {
          FactoryGirl.create(:odds_are, :recipient => other_user)
        }
        let(:invalid_challenge_response) {
          FactoryGirl.attributes_for(:challenge_response,
            :odds_are_id => non_associated_odds_are.id)
        }
        it "throws an error" do
          expect{
            post :create, :params => {
              :challenge_response => invalid_challenge_response,
            }
          }.to raise_error "You must be the recipient off the odds are to respond"
        end
      end

      context "requests with valid challenge response" do
        # Cascade associations to setup valid challenge response
        let(:valid_challenge_request) {
          FactoryGirl.create(:challenge_request)
        }
        let(:valid_notification) {
          FactoryGirl.create(:notification,
                             :notifiable => valid_challenge_request,
                             :recipient => user)
        }
        let(:valid_odds_are) {
          FactoryGirl.create(:odds_are,
                             :recipient => user,
                             :challenge_request => valid_challenge_request)
        }
        let(:valid_challenge_response) {
          FactoryGirl.attributes_for(:challenge_response,
            :odds_are_id => valid_odds_are.id,
            :number_chosen => 10,
            :odds_out_of => 50
          )
        }
        before do
          request.env["HTTP_REFERER"] = "base_path"
          post :create, :params => {
            :challenge_response => valid_challenge_response,
          }
        end

        it "should create a challenge response object" do
          expect( ChallengeResponse.all.size ). to eql 1
        end

        it "should update the odds are's timestamp" do
          expect( OddsAre.first.responded_to_at ).to be_a( Time )
        end

        it "should redirect user back" do
          expect( response ).to redirect_to "base_path"
        end

        it "should create a notification for the odds are's initiator" do
          expect( valid_odds_are.initiator.notifications.size ).to eql 1
        end

        it "should mark the responder's notification as read" do
          expect( Notification.first.acted_upon_at).to be_a( Time )
        end
      end
    end
  end
end

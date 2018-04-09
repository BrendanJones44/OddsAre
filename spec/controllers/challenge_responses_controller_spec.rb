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

      context "requests with valid challenge request" do
        let(:valid_odds_are) {
          FactoryGirl.create(:odds_are, :recipient => user)
        }
        let(:valid_challenge_response) {
          FactoryGirl.attributes_for(:challenge_response,
            :odds_are_id => valid_odds_are.id )
        }
        end
        # context "with correlated odds are" do
        #   before do
        #     valid_challenge_response.
        #   end
        #   it "requires users to be friends" do
        #     expect{
        #       post :create, :params => {
        #         :challenge_request => valid_challenge_request,
        #         :recipient_id => user_receiving_odds_are.id
        #       }
        #     }.to raise_error 'You must be friends with the recpient to odds are them'
        #   end
        #
        #   context "and the users are friends" do
        #     before do
        #       request.env["HTTP_REFERER"] = "base_path"
        #       user.friend_request(user_receiving_odds_are)
        #       user_receiving_odds_are.accept_request(user)
        #       post :create, :params => {
        #         :challenge_request => valid_challenge_request,
        #         :recipient_id => user_receiving_odds_are.id
        #       }
        #     end
        #
        #     it "should create a challenge request object" do
        #       expect(ChallengeRequest.all.size). to eql 1
        #     end
        #
        #     it "should create an odds are object" do
        #       expect(OddsAre.all.size).to eql 1
        #     end
        #
        #     it "should relate the created odds are to the created challenge request" do
        #       expect(OddsAre.first.challenge_request).to eql (ChallengeRequest.first)
        #     end
        #
        #     it "should create a notification for receiving user" do
        #       expect(user_receiving_odds_are.notifications.size).to eql 1
        #     end
        #
        #     it "should update the challenger's sent odds ares" do
        #       expect(user.sent_odds_ares.size).to eql 1
        #     end
        #
        #     it "should update the receiver's received odds ares" do
        #       expect(user_receiving_odds_are.received_odds_ares.size).to eql 1
        #     end
        #
        #     it "should redirect user back" do
        #       expect( response ).to redirect_to "base_path"
        #     end
        #   end
        #end
      end
    end
  end
end

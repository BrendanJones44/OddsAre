require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe ChallengeFinalizationsController, type: :controller do
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

      context "requests with empty challenge finalization" do
        let(:empty_challenge_finalization) { ChallengeFinalization.new() }
        it "should require params not to be empty" do
          expect{
            post :create, params: {
              challenge_finalization: empty_challenge_finalization
             }
          }.to raise_error ActionController::ParameterMissing
        end
      end

      context "requests with non-existent odds are" do
        let(:invalid_challenge_finalization) {
          FactoryGirl.attributes_for(:challenge_finalization)
        }
        it "throws an error" do
          expect{
            post :create, :params => {
              :challenge_finalization => invalid_challenge_finalization
            }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context "requests where the odds are has already been finalized" do
        let(:already_finalized_odds_are) {
          FactoryGirl.create(:odds_are,
                             :initiator => user,
                             :finalized_at => Time.zone.now)
        }
        let(:challenge_finalization) {
          FactoryGirl.attributes_for(:challenge_finalization,
                                     :odds_are_id => already_finalized_odds_are.id)
        }
        it "throws an error" do
          expect{
            post :create, :params => {
              :challenge_finalization => challenge_finalization
            }
          }.to raise_error "This odds are has already been completed"
        end
      end

      context "requests where the odds are initiator isn't the user" do
        let(:other_user) { FactoryGirl.create(:user) }
        let(:non_associated_odds_are) {
          FactoryGirl.create(:odds_are, :initiator => other_user)
        }
        let(:invalid_challenge_finalization) {
          FactoryGirl.attributes_for(:challenge_finalization,
          :odds_are_id => non_associated_odds_are.id)
        }
        it "throws an error" do
          expect{
            post :create, :params => {
              :challenge_finalization => invalid_challenge_finalization,
            }
          }.to raise_error "You must be the initiator of the odds are to respond"
        end
      end

      context "requets with valid challenge finalization, but no winner" do
        let(:challenge_response) {
          FactoryGirl.create(:challenge_response,
          :odds_are_id => 1,
          :number_chosen => 10,
          :odds_out_of => 50
          )
        }
        let(:associated_odds_are) {
          FactoryGirl.create(:odds_are, :initiator => user, :challenge_response => challenge_response)
        }

        let(:challenge_finalization) {
          FactoryGirl.attributes_for(:challenge_finalization,
          :odds_are_id => associated_odds_are.id)
        }

        before do
          request.env["HTTP_REFERER"] = "base_path"
          post :create, :params => {
            :challenge_finalization => challenge_finalization
          }
        end

        it "should create a challenge finalization object" do
          expect( ChallengeFinalization.all.size ).to eql 1
        end

        it "should update the odds are's timestamp" do
          expect( OddsAre.first.finalized_at).to be_a( Time )
        end

        it "should redirect user back" do
          expect( response ).to redirect_to "base_path"
        end

        it "should notify the other user the odds are is completed" do
          expect( associated_odds_are.recipient.notifications.size ).to eql 1
        end
      end

    end
  end
end

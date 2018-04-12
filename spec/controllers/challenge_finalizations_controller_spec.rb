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

    end
  end
end

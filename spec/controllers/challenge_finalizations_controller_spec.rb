require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe ChallengeFinalizationsController, type: :controller do
  describe 'POST #create' do
    let(:user) { FactoryGirl.create(:user) }

    context 'anonymous user' do
      it 'should be redirected to signin' do
        post :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      before do
        sign_in user
      end

      context 'requests with no parameters' do
        it 'should require parameters' do
          expect do
            post :create, params: {}
          end.to raise_error ActionController::ParameterMissing
        end
      end

      context 'requests with empty challenge finalization' do
        let(:empty_challenge_finalization) { ChallengeFinalization.new }
        it 'should require params not to be empty' do
          expect do
            post :create, params: {
              challenge_finalization: empty_challenge_finalization
            }
          end.to raise_error ActionController::ParameterMissing
        end
      end

      context 'requests with non-existent odds are' do
        let(:invalid_challenge_finalization) do
          FactoryGirl.attributes_for(:challenge_finalization)
        end
        it 'throws an error' do
          expect do
            post :create, params: {
              challenge_finalization: invalid_challenge_finalization
            }
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'requests where the odds are has already been finalized' do
        let(:already_finalized_odds_are) do
          FactoryGirl.create(:odds_are,
                             initiator: user,
                             finalized_at: Time.zone.now)
        end
        let(:challenge_finalization) do
          FactoryGirl.attributes_for(:challenge_finalization,
                                     odds_are_id: already_finalized_odds_are.id)
        end
        it 'renders an expired link' do
          expect(post(:create, params: {
                        challenge_finalization: challenge_finalization
                      })).to render_template('pages/expired')
        end
      end

      context 'requests where the odds are initiator is not the user' do
        let(:other_user) { FactoryGirl.create(:user) }
        let(:non_associated_odds_are) do
          FactoryGirl.create(:odds_are, initiator: other_user)
        end
        let(:invalid_challenge_finalization) do
          FactoryGirl.attributes_for(:challenge_finalization,
                                     odds_are_id: non_associated_odds_are.id)
        end
        it 'renders an expired link' do
          expect(post(:create, params: {
                        challenge_finalization: invalid_challenge_finalization
                      })).to render_template('pages/expired')
        end
      end

      context 'requests with valid challenge finalization, but no winner' do
        let(:recipient) do
          FactoryGirl.create(:user)
        end

        let(:notification) do
          FactoryGirl.create(:notification)
        end

        let(:challenge_response) do
          FactoryGirl.create(:challenge_response,
                             odds_are_id: 1,
                             number_chosen: 10,
                             odds_out_of: 50,
                             notification: notification)
        end
        let(:associated_odds_are) do
          FactoryGirl.create(:odds_are, initiator: user, recipient: recipient,
                                        challenge_response: challenge_response)
        end

        let(:challenge_finalization) do
          FactoryGirl.attributes_for(:challenge_finalization,
                                     odds_are_id: associated_odds_are.id,
                                     number_guessed: 2)
        end

        before do
          request.env['HTTP_REFERER'] = 'base_path'
          post :create, params: {
            challenge_finalization: challenge_finalization
          }
        end

        it 'should create a challenge finalization object' do
          expect(ChallengeFinalization.all.size).to eql 1
        end

        it 'should update the odds are timestamp' do
          expect(OddsAre.first.finalized_at).to be_a(Time)
        end

        it 'should redirect user back' do
          expect(response).to redirect_to 'base_path'
        end

        it 'should notify the other user the odds are is completed' do
          expect(associated_odds_are.recipient.notifications.size).to eql 1
        end

        it 'should not have created a task' do
          expect(Task.all.size).to eql 0
        end
      end

      context 'requests with valid challenge finalization, with initiator
       winning' do

        let(:recipient) { FactoryGirl.create(:user) }

        let(:challenge_request) do
          FactoryGirl.create(:challenge_request,
                             action: 'Test odds are')
        end

        let(:notification) do
          FactoryGirl.create(:notification)
        end

        let(:challenge_response) do
          FactoryGirl.create(:challenge_response,
                             odds_are_id: 1,
                             number_chosen: 10,
                             odds_out_of: 50,
                             notification: notification)
        end
        let(:associated_odds_are) do
          FactoryGirl.create(:odds_are, initiator: user, recipient: recipient,
                                        challenge_response: challenge_response,
                                        challenge_request: challenge_request)
        end

        let(:challenge_finalization) do
          FactoryGirl.attributes_for(:challenge_finalization,
                                     odds_are_id: associated_odds_are.id,
                                     number_guessed: 40)
        end

        before do
          request.env['HTTP_REFERER'] = 'base_path'
          post :create, params: {
            challenge_finalization: challenge_finalization
          }
        end

        it 'should create a challenge finalization object' do
          expect(ChallengeFinalization.all.size).to eql 1
        end

        it 'should create a task object' do
          expect(Task.all.size).to eql 1
        end

        it 'should have the task object winner be the recipient' do
          expect(Task.first.winner).to eql recipient
        end

        it 'should have the task object loser be the initiator' do
          expect(Task.first.loser).to eql user
        end

        it 'should have the original action as the task action' do
          expect(Task.first.action).to eql challenge_request.action
        end

        it 'should update the odds are timestamp' do
          expect(OddsAre.first.finalized_at).to be_a(Time)
        end

        it 'should redirect user back' do
          expect(response).to redirect_to 'base_path'
        end

        it 'should notify the other user the odds are is completed' do
          expect(associated_odds_are.recipient.notifications.size).to eql 1
        end
      end

      context 'requests with valid challenge finalization, with recpient
      winning' do
        let(:recipient) { FactoryGirl.create(:user) }
        let(:challenge_request) do
          FactoryGirl.create(:challenge_request,
                             action: 'Test odds are')
        end

        let(:challenge_response) do
          FactoryGirl.create(:challenge_response,
                             odds_are_id: 1,
                             number_chosen: 10,
                             odds_out_of: 50,
                             notification: notification)
        end

        let(:notification) do
          FactoryGirl.create(:notification)
        end
        let(:associated_odds_are) do
          FactoryGirl.create(:odds_are,
                             initiator: user,
                             recipient: recipient,
                             challenge_response: challenge_response,
                             challenge_request: challenge_request)
        end

        let(:challenge_finalization) do
          FactoryGirl.attributes_for(:challenge_finalization,
                                     odds_are_id: associated_odds_are.id,
                                     number_guessed: 10)
        end

        before do
          request.env['HTTP_REFERER'] = 'base_path'
          post :create, params: {
            challenge_finalization: challenge_finalization
          }
        end

        it 'should create a challenge finalization object' do
          expect(ChallengeFinalization.all.size).to eql 1
        end

        it 'should create a task object' do
          expect(Task.all.size).to eql 1
        end

        it 'should have the task object winner be the initiator' do
          expect(Task.first.winner).to eql user
        end

        it 'should have the task object loser be the initiator' do
          expect(Task.first.loser).to eql recipient
        end

        it 'should have the original action as the task action' do
          expect(Task.first.action).to eql challenge_request.action
        end

        it 'should update the odds are timestamp' do
          expect(OddsAre.first.finalized_at).to be_a(Time)
        end

        it 'should redirect user back' do
          expect(response).to redirect_to 'base_path'
        end

        it 'should notify the other user the odds are is completed' do
          expect(associated_odds_are.recipient.notifications.size).to eql 1
        end
      end
    end
  end
end

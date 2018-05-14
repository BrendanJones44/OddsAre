require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe ChallengeResponsesController, type: :controller do
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

      context 'requests with empty challenge response' do
        let(:empty_challenge_response) { ChallengeResponse.new }
        it 'throws an error' do
          expect do
            post :create, params: {
              challenge_response: empty_challenge_response
            }
          end.to raise_error ActionController::ParameterMissing
        end
      end

      context 'requests with non-existent odds are' do
        let(:invalid_challenge_response) do
          FactoryGirl.attributes_for(:challenge_response)
        end
        it 'throws an error' do
          expect do
            post :create,
                 params: { odds_are_id: 1,
                           challenge_response: invalid_challenge_response }
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'requests where the odds are recipient is not the user' do
        let(:other_user) { FactoryGirl.create(:user) }
        let(:non_associated_odds_are) do
          FactoryGirl.create(:odds_are, recipient: other_user)
        end
        let(:invalid_challenge_response) do
          FactoryGirl.attributes_for(:challenge_response,
                                     odds_are_id: non_associated_odds_are.id)
        end
        it 'throws an error' do
          expect do
            post :create, params: {
              challenge_response: invalid_challenge_response
            }
          end.to raise_error 'You must be the recipient off the odds are ' \
                             'to respond'
        end
      end

      context 'requests with valid challenge response' do
        # Cascade associations to setup valid challenge response
        let(:valid_notification) do
          FactoryGirl.create(:notification,
                             recipient: user)
        end
        let(:valid_challenge_request) do
          FactoryGirl.create(:challenge_request,
                             notification: valid_notification)
        end
        let(:valid_odds_are) do
          FactoryGirl.create(:odds_are,
                             recipient: user,
                             challenge_request: valid_challenge_request)
        end
        let(:valid_challenge_response) do
          FactoryGirl.attributes_for(:challenge_response,
                                     odds_are_id: valid_odds_are.id,
                                     number_chosen: 10,
                                     odds_out_of: 50)
        end
        before do
          request.env['HTTP_REFERER'] = 'base_path'
          post :create, params: {
            challenge_response: valid_challenge_response
          }
        end

        it 'should create a challenge response object' do
          expect(ChallengeResponse.all.size). to eql 1
        end

        it 'should update the odds are timestamp' do
          expect(OddsAre.first.responded_to_at).to be_a(Time)
        end

        it 'should update the odds are association' do
          expect(OddsAre.first.challenge_response).to be_a(ChallengeResponse)
        end

        it 'should update the notification created from the request' do
          expect(OddsAre.first.challenge_request.notification.acted_upon_at)
            .to be_a(Time)
        end

        it 'should redirect user back' do
          expect(response)
            .to redirect_to(odds_ares_show_current_path(show_friends: 'active'))
        end

        it 'should create a notification for the odds are initiator' do
          expect(valid_odds_are.initiator.notifications.size).to eql 1
        end

        it 'should mark the responder notification as read' do
          expect(Notification.first.acted_upon_at).to be_a(Time)
        end
      end

      context 'requests with invalid challenge response' do
        # Cascade associations to setup valid challenge response
        let(:valid_notification) do
          FactoryGirl.create(:notification,
                             recipient: user)
        end
        let(:valid_challenge_request) do
          FactoryGirl.create(:challenge_request,
                             notification: valid_notification)
        end
        let(:valid_odds_are) do
          FactoryGirl.create(:odds_are,
                             recipient: user,
                             challenge_request: valid_challenge_request)
        end
        let(:invalid_challenge_response) do
          FactoryGirl.attributes_for(:challenge_response,
                                     odds_are_id: valid_odds_are.id,
                                     number_chosen: 0,
                                     odds_out_of: 50)
        end
        before do
          post :create, params: {
            challenge_response: invalid_challenge_response
          }
        end

        it 'should redirect user to challenge response form' do
          expect(response).to render_template('challenge_requests/show/')
        end
      end
    end
  end

  describe 'GET #show' do
    context 'anonymous user' do
      let(:odds_are) { FactoryGirl.create(:odds_are) }
      let(:challenge_response) do
        FactoryGirl.create(:challenge_response,
                           odds_are: odds_are)
      end
      it 'should be redirected to signin' do
        get :show, params: { id: challenge_response.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        sign_in user
      end
      context 'with unfinalized odds are' do
        context 'who is not associated to the odds are' do
          let(:odds_are) { FactoryGirl.create(:odds_are) }
          let(:challenge_response) do
            FactoryGirl.create(:challenge_response,
                               odds_are: odds_are)
          end
          it 'should render expired link' do
            get :show, params: { id: challenge_response.id }
            expect(response).to render_template('pages/expired')
          end
        end

        context 'who is the recipient of the odds are' do
          let(:odds_are) { FactoryGirl.create(:odds_are, recipient: user) }
          let(:challenge_response) do
            FactoryGirl.create(:challenge_response,
                               odds_are: odds_are)
          end
          it 'should render the page' do
            get :show, params: { id: challenge_response.id }
            expect(response).to render_template('pages/expired')
          end
        end

        context 'who is the initiator of the odds are' do
          let(:odds_are) { FactoryGirl.create(:odds_are, initiator: user) }
          let(:challenge_response) do
            FactoryGirl.create(:challenge_response,
                               odds_are: odds_are)
          end
          it 'should render the page' do
            get :show, params: { id: challenge_response.id }
            expect(response).to render_template('show')
          end
        end
      end

      context 'finalized odds are' do
        context 'who is not associated to the odds are' do
          let(:odds_are) do
            FactoryGirl.create(:odds_are,
                               finalized_at: Time.zone.now)
          end
          let(:challenge_response) do
            FactoryGirl.create(:challenge_response,
                               odds_are: odds_are)
          end
          it 'should render expired link' do
            get :show, params: { id: challenge_response.id }
            expect(response).to render_template('pages/expired')
          end
        end

        context 'who is the recipient of the odds are' do
          let(:odds_are) do
            FactoryGirl.create(:odds_are,
                               finalized_at: Time.zone.now, recipient: user)
          end
          let(:challenge_response) do
            FactoryGirl.create(:challenge_response,
                               odds_are: odds_are)
          end
          it 'should render the page' do
            get :show, params: { id: challenge_response.id }
            expect(response).to render_template('odds_ares/show')
          end
        end

        context 'who is the initiator of the odds are' do
          let(:odds_are) do
            FactoryGirl.create(:odds_are,
                               finalized_at: Time.zone.now, initiator: user)
          end
          let(:challenge_response) do
            FactoryGirl.create(:challenge_response,
                               odds_are: odds_are)
          end
          it 'should render the page' do
            get :show, params: { id: challenge_response.id }
            expect(response).to render_template('odds_ares/show')
          end
        end
      end
    end
  end
end

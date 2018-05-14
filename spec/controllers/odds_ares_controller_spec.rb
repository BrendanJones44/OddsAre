require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe OddsAresController, type: :controller do
  describe '#show' do
    context 'unauthenticated user' do
      let(:odds_are) { FactoryGirl.create(:odds_are) }
      it 'should be redirected to signin' do
        get :show, params: { id: odds_are.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
      end
      context 'who is the recipient of the notification' do
        subject { FactoryGirl.create(:notification, recipient: user) }
        let(:odds_are) { FactoryGirl.create(:odds_are, notification: subject) }
        context 'and the notification hasn not been read yet' do
          it 'should update the notification' do
            get :show, params: { id: odds_are.id }
            expect(subject.reload.acted_upon_at). to be_a Time
          end
        end

        context 'and the notification has already been read' do
          subject do
            FactoryGirl.create(:notification,
                               recipient: user, acted_upon_at: Time.zone.now)
          end
          let(:odds_are) do
            FactoryGirl.create(:odds_are,
                               notification: subject)
          end
          it 'should not override the notifications timestamp' do
            expect { get :show, params: { id: odds_are.id } }
              .to_not change { subject.acted_upon_at }
          end
        end
      end

      context 'who is is not the recipient of the notification' do
        subject do
          FactoryGirl.create(:notification,
                             acted_upon_at: Time.zone.now)
        end
        let(:odds_are) { FactoryGirl.create(:odds_are, notification: subject) }
        it 'should not override the notifications timestamp' do
          expect { get :show, params: { id: odds_are.id } }
            .to_not change { subject.acted_upon_at }
        end
      end
    end
  end

  describe '#show_current' do
    context 'unauthenticated user' do
      it 'should be redirected to signin' do
        get :show_current
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'authenticated user' do
      context 'with odds ares waiting on them to set' do
        let(:user) { user_receiving_odds_are_with_no_response }
        before do
          sign_in user
        end
        it 'assigns the challenge requests waiting on the user properly' do
          get :show_current
          expect(assigns(:requests_waiting_on_user_to_set))
            .to eql user.challenge_requests_waiting_on_user_to_set
        end
      end

      context 'with odds ares waiting on friends to set' do
        let(:user) { user_initiating_odds_are_with_no_response }
        before do
          sign_in user
        end
        it 'assigns the challenge requests waiting on friends properly' do
          get :show_current
          expect(assigns(:requests_waiting_on_friends_to_set))
            .to eql user.challenge_requests_waiting_on_friends_to_set
        end
      end

      context 'with odds ares waiting on them to complete' do
        let(:user) { user_initiating_odds_are_with_no_response }
        before do
          sign_in user
        end
        it 'assigns the challenge responses waiting on the user properly' do
          get :show_current
          expect(assigns(:responses_waiting_on_user_to_complete))
            .to eql user.challenge_responses_waiting_on_friends_to_complete
        end
      end

      context 'with odds ares waiting on friends to complete' do
        let(:user) { user_initiating_odds_are_with_no_response }
        before do
          sign_in user
        end
        it 'assigns the challenge responses waiting on friends properly' do
          get :show_current
          expect(assigns(:responses_waiting_on_friends_to_complete))
            .to eql user.challenge_responses_waiting_on_user_to_complete
        end
      end

      context 'with show friends parameter' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          sign_in user
        end
        it 'assigns the proper css instance variables' do
          get :show_current, params: { show_friends: true }
          expect(assigns(:show_friends)).to eql 'active'
          expect(assigns(:style_hide)).to eql 'display:none'
          expect(assigns(:style_show)).to eql 'display:inline'
        end
      end
    end
  end
end

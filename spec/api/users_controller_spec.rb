require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  describe 'POST #authentication_and_metadata' do
    subject { post :authenticate_and_metadata, params: params }

    let(:stubbed_auth_token) { 'STUBBED_AUTH_TOKEN' }

    let(:valid_email) { 'sample@email.com' }
    let(:valid_password) { 'Password1!' }
    let(:valid_parameters) do
      {
        'email': valid_email,
        'password': valid_password
      }
    end

    let!(:user) do
      FactoryGirl.create(:user, email: valid_email, password: valid_password)
    end

    context 'with valid credentials' do
      let(:params) { valid_parameters }

      it 'should respond with 200' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'should render authenticated json' do
        expect(subject).to render_template(:authenticated_with_metadata)
      end

      it 'should set the correct response data' do
        subject

        aggregate_failures do
          expect(assigns(:notifications)).to eq user.notification_feed
          expect(assigns(:friends)).to eq user.filtered_friends
          expect(assigns(:user_id)).to eq user.id
        end
      end

      it 'should set a user auth token in the header' do
        allow_any_instance_of(User).to receive(:new_auth_token)
          .and_return stubbed_auth_token

        subject

        expect(response.headers['auth_token']).to eq stubbed_auth_token
      end
    end

    context 'with invalid credentials' do
      let(:invalid_password) { 'WRONG_PASSWORD' }
      let(:params) { { 'email': valid_email, 'password': invalid_password } }

      it 'should respond with 401' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end

      it 'should render failed_authentication' do
        expect(subject).to render_template(:failed_authentication)
      end
    end

    context 'with unknown email address' do
      let(:invalid_email) { 'WRONG_EMAIL@email.com' }
      let(:params) { { email: invalid_email, password: valid_password } }

      it 'should respond with 404' do
        subject
        expect(subject).to have_http_status(:not_found)
      end

      it 'should render not_found_by_email' do
        subject
        expect(subject).to render_template(:not_found_by_email)
      end

      it 'should assign the email in the response data' do
        subject
        expect(assigns(:invalid_email)).to eq invalid_email
      end
    end
  end
end

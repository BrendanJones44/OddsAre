require 'rails_helper'
require './spec/support/authentication_helpers'

RSpec.configure do |c|
  c.include AuthenticationHelpers
end

RSpec.describe 'POST /users/sign_in', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:url) { '/users/sign_in' }
  let(:headers) do
    { 'Content-Type' => 'application/json' }
  end
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'with valid params' do
    before do
      post url, params: params
    end

    it 'returns 302' do
      expect(response).to have_http_status(302)
    end

    it 'returns JWT token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      decoded_token = decoded_jwt_token_from_response(response)
      expect(decoded_token.first['sub']).to be_present
    end
  end
end

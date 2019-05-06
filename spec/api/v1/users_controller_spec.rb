# require 'rails_helper'

# RSpec.describe Api::V1::UsersController, type: :controller do
#   describe 'GET #metadata' do
#     context 'authenticated user' do
#       let(:user) { FactoryGirl.create(:user) }
#       let(:headers) do
#         {
#           'Content-Type': 'application/json',
#           'Accept': 'application/json'
#         }.merge(user.create_new_auth_token)
#       end
#       before do
#         sign_in user
#       end

#       it 'should respond with found' do
#         get :metadata, headers: headers
#         expect(response).to have_http_status(200)
#       end

#       it 'should respond with the users notifications' do
#         get :metadata, headers: headers
#         parsed_body = JSON.parse(response.body)
#         expect(parsed_body).to match_array(user.notifications.needs_action)
#       end
#     end
#   end
# end

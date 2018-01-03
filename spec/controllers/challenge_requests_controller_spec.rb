require 'rails_helper'

RSpec.describe ChallengeRequestsController, type: :controller do

  describe "GET #new" do
    context "with unauthorized user" do
      it "blocks the request" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end

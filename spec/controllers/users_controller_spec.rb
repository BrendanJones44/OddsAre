require 'rails_helper'
require './spec/support/user_helpers'

RSpec.configure do |c|
  c.include UserHelpers
end

RSpec.describe UsersController, type: :controller do
  describe "#show" do
    context "unauthenticated user" do
      it "should be redirected to signin" do
        get :show, params: { id: 100 }
        expect( response ).to redirect_to( new_user_session_path )
      end
    end

    context "authenticated user" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
      end
      it "assigns the user correctly" do
        get :show, params: { friendly: user.slug }
        expect(assigns(:user)).to eql user
      end
    end
  end

  describe "#all" do
    context "unauthenticated user" do
      it "should be redirected to signin" do
        get :all
        expect( response ).to redirect_to( new_user_session_path )
      end
    end

    context "authenticated user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        get :all
      end
      it "assigns the view type to be all users" do
        expect(assigns(:users)).to match_array [other_user]
      end
      it "assigns users to all users but the currently logged in one" do
        expect(assigns(:view_type)).to eql "All Users"
      end
    end
  end

  describe "#friends" do
    context "unauthenticated user" do
      it "should be redirected to signin" do
        get :friends
        expect( response ).to redirect_to( new_user_session_path )
      end
    end

    context "authenticated user" do
      let(:user) { get_user_with_friends }
      before do
        sign_in user
        get :friends
      end

      it "should assign the view type to be Your Friends" do
        expect(assigns(:view_type)).to eql "Your Friends"
      end

      it "should assign the users to display to be the users friends" do
        expect(assigns(:users)).to match_array user.friends
      end

      it "should render the users/all template" do
        expect(response).to render_template('users/all')
      end
    end
  end
end

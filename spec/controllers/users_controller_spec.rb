require 'spec_helper'

describe UsersController do
  describe 'user access' do 
    before :each do
      session[:user_id] = create(:user).id
    end

    it "GET#index denies access" do
      get :index
      response.should redirect_to root_url
    end

    it "GET#new denies access" do
      get :new
      response.should redirect_to root_url
    end

    it "POST#create denies access" do
      post :create, user: attributes_for(:user)
      response.should redirect_to root_url
    end
  end
end
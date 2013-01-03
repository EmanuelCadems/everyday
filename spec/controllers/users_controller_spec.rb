require 'spec_helper'

describe UsersController do
  describe 'guest access' do
    it "GET#index require login", :guest => true do
      get :index
      response.should require_login
    end

    it "GET#new" do
      get :new
      response.should require_login
    end

    it "POST#create" do
      post :create, user:attributes_for(:user)
      response.should require_login
    end

  end

  describe 'user access' do 
    before :each do
      session[:user_id] = create(:user).id
    end

    it "GET#index denies access" do
      get :index
      # response.should redirect_to root_url
      response.should require_login
    end

    it "GET#new denies access" do
      get :new
      response.should require_login
      # response.should redirect_to root_url
    end

    it "POST#create denies access" do
      post :create, user: attributes_for(:user)
      response.should require_login
      # response.should redirect_to root_url
    end
  end

  describe 'admin access' do
    before :each do
      @admin = create(:admin)
      session[:user_id] = @admin.id
    end
    describe "GET#index" do
      it "collects users into @users" do
        user = create(:user)
        get :index
        assigns(:users).should eq [@admin, user]
      end
      it "renders index template" do
        get :index
        response.should render_template :index
      end
    end

    describe "GET#new", :new => true do
      it "assigns user into @user" do
        get :new
        assigns(:user).should be_a_new(User)
      end

      it "renders template new" do
        get :new
        response.should render_template :new
      end
    end

    describe "POST#create" do
      it "creates a user into db" do
        expect{
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it "renders index template" do
        post :create, user:attributes_for(:user)
        response.should redirect_to users_url
      end
    end

  end

end
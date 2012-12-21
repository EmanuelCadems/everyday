require 'spec_helper'

describe ContactsController do
  describe "guest access" do
    describe 'GET #index' do
      it "populate an array of contacts" do
        contact = create(:contact)
        get :index
        assigns(:contacts).should eq [contact]
      end

      it "renders the :index template" do
        get :index
        response.should render_template :index
      end
    end 

    describe 'GET #show' do
      it "assigns the requested contact to @contact" do
        contact = create(:contact)
        get :show, id: contact
        assigns(:contact).should eq contact
      end

      it "renders the :show template" do
        contact = create(:contact)
        get :show, id: contact
        response.should render_template :show
      end
    end

    describe 'GET #new' do
      it "requires login" do
        get :new
        response.should redirect_to login_url
      end
    end

    describe 'POST #create' do
      it "requires login"
    end

    describe 'PUT #update' do
      it "requires login"
    end

    describe 'DELETE #destroy' do
      it "requires login"
    end
  end

  describe "admin access"do
    describe 'GET #index' do
      it "populates an array of contacts"
      it "render teh :index view"
    end

    describe 'GET #show' do
      it "assigns the requested contact to @contact"
      it "renders the :show template"
    end

    describe 'GET #new' do
      it "assigns the new Contact to @contact"
      it "renders the new template"
    end

    describe 'POST #create' do
      context "with valid attributes" do
        it "saves the new contact in the database"
        it "redirects to the home page"
      end

      context "with invalid attributes" do
        it "does not save the new contact in the database"
        it "re-renders the :new template"
      end
    end

    describe 'PUT #update' do
      context "with a valid attributes" do
        it "updates the contact in the database"
        it "redirects to the :contact"
      end

      context "with a invalid attributes" do
        it "does not update the contact in the database"
        it "re-renders the :edit template"
      end
    end

  end

  describe "user access"do
    describe 'GET #index' do
      it "return an array with a contacts"
      it "renders the :index view"
    end
    
    describe 'GET #show' do
      it "assigns the contact requested to @contact"
      it "renders the :show template"
    end

    describe 'GET #new' do
      it "assigns the new Contact to @contact"
      it "renders the :new template"
    end

    describe 'POST #create' do
      context 'with a valid attributes' do
        it "saves the new contact in the database"
        it "redirect to the home page"
      end

      context 'with a invalid attributes' do 
        it "does not save the contact in the database"
        it "re-renders the :edit template"
      end
    end

    describe 'PUT #update' do
      context 'with valid attributes' do
        it "updates the contact in the database"
        it "redirect to the contact"
      end

      context 'with invalid attributes' do
        it "does not update the contact"
        it "re-renders :edit template"
      end
    end

    describe 'DELETE #destroy' do
      it "delete the contact from the database"
      it "redirects to the home page"
    end
  end
end
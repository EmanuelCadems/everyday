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

    describe 'GET #edit' do
      it "requires login" do
        get :edit, id: create(:contact)
        response.should redirect_to login_url
      end
    end

    describe 'POST #create' do
      it "requires login" do
        post :create, id: create(:contact), contact: attributes_for(:contact)
        response.should redirect_to login_url
      end
    end

    describe 'PUT #update' do
      it "requires login" do
        put :update, id: create(:contact), contact: attributes_for(:contact)
        response.should redirect_to login_url
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        delete :destroy, id: create(:contact)
        response.should redirect_to login_url
      end
    end
  end

  describe "admin access"do
    before :each do
      @contact = create(:contact, firstname: 'Emanuel', lastname: 'Alarcon' )
      user = create(:admin)
      session[:user_id] = user.id
      Rails.logger.debug "****************************************************************************"
      Rails.logger.debug "sesion : #{user.id}"
    end

    describe 'GET #index' do
      it "populates an array of contacts" do        
        get :index
        assigns(:contacts).should eq [@contact]
      end
      it "render teh :index view" do
        get :index
        response.should render_template :index
      end
    end

    describe 'GET #show' do
      it "assigns the requested contact to @contact" do
        get :show, id: @contact
        assigns(:contact).should eq @contact
      end

      it "renders the :show template" do      
        get :show, id: @contact
        response.should render_template :show
      end
    end

    describe 'GET #new' do
      it "assigns the new Contact to @contact" do        
        get :new
        assigns(:contact).should be_a_new(Contact)
      end

      it "assigns a home, office, and mobile phone to the new contact" do
        get :new
        assigns(:contact).phones.map do |c|
          c.phone_type
        end.should eq %w(home office mobile)
      end

      it "renders the new template" do
        get :new
        response.should render_template :new
      end
    end

    describe 'GET #edit' do
      it"asssigns the requested contacto to @contact" do
        get :edit, id: @contact
        assigns(:contact).should eq @contact
      end

      it"renders the edit template" do
        get :edit, id: @contact
        response.should render_template :edit
      end
    end
    describe 'POST #create' do
      before :each do
        @phones = [
          attributes_for(:phone, phone_type: "home"),
          attributes_for(:phone, phone_type: "office"),
          attributes_for(:phone, phone_type: "mobile")
        ]
      end

      context "with valid attributes" do
        it "creates the new contact" do
          expect{
            post :create, contact: attributes_for(:contact,
                phones_attributes: @phones)              
          }.to change(Contact, :count).by(1)
        end

        it "redirects to the new contact" do
          post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          response.should redirect_to Contact.last
        end
      end

      context "with invalid attributes" do
        it "does not save the new contact in the database" do
          expect{
            post :create, contact: attributes_for(:invalid_contact, phones_attributes: @phones)
          }.to_not change(Contact, :count)
        end
        
        it "re-renders the :new template" do
          post :create, attributes_for(:invalid_contact)
          response.should render_template :new
        end
      end
    end

    describe 'PUT #update' do
      context "with a valid attributes" do
        it "locates the requested @contact" do
          put :update, id: @contact, contact: attributes_for(:contact)
          assigns(:contact).should eq @contact
        end

        it "change @contact's attributes" do
          put :update, id: @contact, contact: attributes_for(:contact, 
            firstname: 'Jose', lastname: 'Arcadio')
          @contact.reload
          @contact.firstname.should eq('Jose')
          @contact.lastname.should eq('Arcadio')
        end

        it "redirects to the :contact" do
          put :update, id: @contact, contact: attributes_for(:contact)
          response.should redirect_to @contact
        end
      end

      context "with a invalid attributes" do
        it "locates the requested @contact" do
          put :update, id: @contact, contact:attributes_for(:invalid_contact)
          Rails.logger.debug "********      attributes_for      *****************"
          Rails.logger.debug "#{attributes_for(:invalid_contact)}"
          Rails.logger.debug "____________________________________________________"
          assigns(:contact).should eq @contact
        end

        it "does not change @contact's attributes" do
          put :update, id: @contact, contact:attributes_for(:contact, 
            firstname: 'Samanta', lastname: nil)
          @contact.reload
          @contact.firstname.should_not eq ('Samanta')
          @contact.lastname.should eq('Alarcon')
        end

        it "re-renders the :edit template" do 
          put :update, id: @contact, contact: attributes_for(:invalid_contact)
          response.should render_template :edit
        end
      end
    end

    describe 'DELETE destroy' do
      it "delete the contact" do
        expect{
          delete :destroy, id: @contact
        }.to change(Contact, :count).by(-1)
      end

      it "redirect to contacts#index" do
        delete :destroy, id: @contact
        response.should redirect_to contacts_url
      end
    end
  end

  describe "user access"do
    before :each do
      @contact = create(:contact, firstname: 'Samanta', lastname: 'Ursula')
      user = create(:user)
      session[:user_id] = user.id
    end

    describe 'GET #index' do
      it "return an array with a contacts" do
        get :index
        assigns(:contacts).should eq [@contact]
      end

      it "renders the :index view" do
        get :index
        response.should render_template :index
      end
    end
    
    describe 'GET #show' do
      it "assigns the contact requested to @contact" do
        get :show, id: @contact
        assigns(:contact).should eq @contact
      end

      it "renders the :show template" do
        get :show, id: @contact
        response.should render_template :show
      end
    end

    describe 'GET #new' do
      it "assigns the new Contact to @contact" do
        get :new
        assigns(:contact).should be_a_new(Contact)
      end

      it "assigns the home, office and mobile phones to the contact" do
        get :new
        assigns(:contact).phones.map do |phone|
          phone.phone_type 
        end.should eq %w(home office mobile)
      end

      it "renders the :new template" do
        get :new
        response.should render_template :new
      end
    end

    describe 'POST #create' do
      before :each do
        @phones = [
          attributes_for(:phone, phone_type: 'home'),
          attributes_for(:phone, phone_type: 'office'),
          attributes_for(:phone, phone_type: 'mobile')
        ]
      end

      context 'with a valid attributes' do
        it "saves the new contact in the database" do
          expect{
            post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          }.to change(Contact, :count).by(1)
        end

        it "redirect to the home page" do
          post :create, contact: attributes_for(:contact, phones_attributes:@phones)
          response.should redirect_to Contact.last
        end
      end

      context 'with a invalid attributes' do 
        it "does not save the contact in the database" do
          expect{
            post :create, contact: attributes_for(:invalid_contact, phones_attributes: @phones)
          }.to_not change(Contact, :count)
        end

        it "re-renders the :new template" do
          post :create, contact: attributes_for(:invalid_contact)
          response.should render_template :new
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid attributes' do
        it "locates the requested contact" do
          put :update, id: @contact, contact: attributes_for(:contact)
          assigns(:contact).should eq @contact
        end

        it "change @contact's attributes" do
          put :update, id: @contact, contact: attributes_for(:contact, 
            firstname: 'Carlos', lastname: 'Santana')
          @contact.reload
          @contact.firstname.should eq('Carlos')
          @contact.lastname.should eq('Santana')
        end

        it "redirect to the contact" do
          put :update, id: @contact, contact: attributes_for(:contact)
          response.should redirect_to @contact 
        end
      end

      context 'with invalid attributes' do
        it "locates the requested contact" do
          put :update, id: @contact, contact: attributes_for(:invalid_contact)
          assigns(:contact).should eq @contact
        end

        it "does not change contact's attributes" do
          put :update, id: @contact, contact: attributes_for(:contact, 
            firstname: 'Pedro', lastname: nil)
          @contact.reload
          @contact.firstname.should_not eq('Pedro')
          @contact.lastname.should eq('Ursula')
        end

        it "re-renders :edit template" do
          put :update, id: @contact, contact: attributes_for(:invalid_contact)
          response.should render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      it "delete the contact from the database" do
        expect{
          delete :destroy, id: @contact
        }.to change(Contact, :count).by(-1)
      end

      it "redirects to the home page" do
        delete :destroy, id: @contact
        response.should redirect_to contacts_url
      end
    end
  end
end
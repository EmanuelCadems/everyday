require 'spec_helper'

describe ContactsController do
  #before :each do
  #  @contact = create(:contact, firstname: 'Emanuel', lastname: 'Alarcon')
  #end
  let(:contact) do
    create(:contact, firstname:'Emanuel', lastname:'Alarcon')
  end

  shared_examples("public access to contacts") do
    describe 'GET #index' do
      it "populates an array of contacts" do        
        get :index
        assigns(:contacts).should eq [contact]
      end
      it "render teh :index view" do
        get :index
        response.should render_template :index
      end
    end

    describe 'GET #show' do
      it "assigns the requested contact to contact" do
        get :show, id: contact
        assigns(:contact).should eq contact
      end

      it "renders the :show template" do      
        get :show, id: contact
        response.should render_template :show
      end
    end
  end

  shared_examples("full access to contacts") do
    describe 'GET #new' do
      it "assigns the new Contact to contact" do        
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
      it"asssigns the requested contacto to contact" do
        get :edit, id: contact
        assigns(:contact).should eq contact
      end

      it"renders the edit template" do
        get :edit, id: contact
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
        it "locates the requested contact" do
          put :update, id: contact, contact: attributes_for(:contact)
          assigns(:contact).should eq contact
        end

        it "change contact's attributes" do
          put :update, id: contact, contact: attributes_for(:contact, 
            firstname: 'Jose', lastname: 'Arcadio')
          contact.reload
          contact.firstname.should eq('Jose')
          contact.lastname.should eq('Arcadio')
        end

        it "redirects to the :contact" do
          put :update, id: contact, contact: attributes_for(:contact)
          response.should redirect_to contact
        end
      end

      context "with a invalid attributes" do
        it "locates the requested contact" do
          put :update, id: contact, contact:attributes_for(:invalid_contact)
          assigns(:contact).should eq contact
        end

        it "does not change contact's attributes" do
          put :update, id: contact, contact:attributes_for(:contact, 
            firstname: 'Samanta', lastname: nil)
          contact.reload
          contact.firstname.should_not eq ('Samanta')
          contact.lastname.should eq('Alarcon')
        end

        it "re-renders the :edit template" do 
          put :update, id: contact, contact: attributes_for(:invalid_contact)
          response.should render_template :edit
        end
      end
    end

    describe 'DELETE destroy' do
      it "delete the contact" do
        contact
        expect{
          delete :destroy, id: contact
        }.to change(Contact, :count).by(-1)
      end

      it "redirect to contacts#index" do
        contact
        delete :destroy, id: contact
        response.should redirect_to contacts_url
      end
    end
  end


  describe "admin access"do
    before :each do
      set_user_session(create(:admin))
    end

    it_behaves_like "public access to contacts"
    it_behaves_like "full access to contacts"

  end

  describe "user access"do
    before :each do
      set_user_session(create(:user))
    end

    it_behaves_like "public access to contacts"
    it_behaves_like "full access to contacts"

  end

  describe "guest access" do
    it_behaves_like "public access to contacts"
    
    describe 'GET #new' do
      it "requires login" do
        get :new
        response.should require_login
        # response.should redirect_to login_url
      end
    end

    describe 'GET #edit' do
      it "requires login" do
        get :edit, id: create(:contact)
        response.should require_login
        # response.should redirect_to login_url
      end
    end

    describe 'POST #create' do
      it "requires login" do
        post :create, id: create(:contact), contact: attributes_for(:contact)
        # response.should redirect_to login_url
        response.should require_login
      end
    end

    describe 'PUT #update' do
      it "requires login" do
        put :update, id: create(:contact), contact: attributes_for(:contact)
        # response.should redirect_to login_url
        response.should require_login
      end
    end

    describe 'DELETE #destroy' do
      it "requires login" do
        contact
        delete :destroy, id: create(:contact)
        # response.should redirect_to login_url
        response.should require_login
      end
    end
  end

end

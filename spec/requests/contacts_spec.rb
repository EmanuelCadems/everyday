require 'spec_helper'
describe "Manage contacts" do
  before :each do
    user = create(:user, email:'ma@gmail.com')
    sign_in user
  end

  it "shows a list of contacts" do
    contact = create(:contact)
    visit contacts_path
    page.should have_content contact.firstname
    page.should have_content contact.lastname
    # page.should have_content contact.pho
  end

  it "shows a requested contact" do
    contact = create(:contact)
    visit contacts_path
    click_link contact.name
    
    page.should have_content contact.name
  end

  it "deletes contact", js: true do
    contact = create(:contact, firstname: 'Juan', lastname: 'Alarcon')
    visit root_path

    expect{
      within "#contact_#{contact.id}" do
        click_link "Destroy"
      end
      sleep(3)
      alert = page.driver.browser.switch_to.alert
      alert.accept
      sleep(3)
    }.to change(Contact, :count).by(-1)

    page.should have_content "Contacts"
    page.should_not have_content "Juan Alarcon"
  end

  describe "New Contact" do
    context "with a user registered" do
      it "create a new contact" do
        user = create(:user)
        sign_in user
        contact = create(:contact)

        expect{
          click_link 'New Contact'
          fill_in 'Firstname', with: contact.firstname
          fill_in 'Lastname', with: contact.lastname
          fill_in 'Email', with: contact.email
          fill_in 'home', with: contact.phones.where(:phone_type => 'home')
          fill_in 'office', with: contact.phones.where(:phone_type => 'work')
          fill_in 'mobile', with: contact.phones.where(:phone_type => 'mobile')
          click_button 'Create Contact'
          page.should have_content 'Contact was successfully created.'
          page.should have_content contact.name
        }.to change(Contact, :count).by(1)
      end
    end

    context "without a user registered" do
      pending
    end
  end
end


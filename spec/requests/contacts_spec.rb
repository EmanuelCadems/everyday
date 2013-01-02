require 'spec_helper'
describe "Manage contacts" do
  before :each do
    user = create(:user, email:'ma@gmail.com')
    sign_in user

    Rails.logger.debug "*******************************************************"
    Rails.logger.debug "user email: #{user.email} user password : #{user.password}"
    Rails.logger.debug "*******************************************************"
  end

  it "deletes contact", js: true do
    contact = create(:contact, firstname: 'Juan', lastname: 'Alarcon')
    Rails.logger.debug "*******************************************************"
    Rails.logger.debug "Ultimo Contacto #{Contact.last.firstname}"
    Rails.logger.debug "firstname: #{contact.firstname} lastname: #{contact.lastname} email:#{contact.email} phones: #{contact.phones}"
    Rails.logger.debug "*******************************************************"
    visit root_path
    expect{
      within "#contact_#{contact.id}" do
        click_link "Destroy"
      end
      alert = page.driver.browser.switch_to.alert
      alert.accept  
    }.to change(Contact, :count).by(-1)
    page.should have_content "Contacts"
    page.should_not have_content "Juan Alarcon"
  end
end
require 'spec_helper'
describe "Manage contacts" do
  before :each do
    user = create(:user)
    sign_in(user)
  end

  it "deletes contact" do
    contact = create(:contact, firstname: 'Juan', lastname: 'Alarcon')
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
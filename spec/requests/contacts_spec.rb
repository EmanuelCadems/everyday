#encoding=utf-8
require 'spec_helper'

describe "Contacts" do
  describe "Views Contacts" do
    before :each do
      @contact = create(:contact)
    end

    it "shows a list of contacts" do
      visit contacts_path
      page.should have_content @contact.firstname
      page.should have_content @contact.lastname

      # page.should have_content contact.pho
    end

    it "shows a requested contact" do
      visit contacts_path
      click_link @contact.name
      page.should have_content @contact.name
      @contact.phones.each do |phone|
        page.should have_content phone.phone
      end
    end
  end

  describe "Manage contacts" do
    before :each do
      user = create(:user)
      sign_in user
    end

    it "create a new contact" do
      # MUY IMPORTANTE: si bien podría usar FactoryGirl para no tener que escribir los datos,
      # no es lo adecuado. Es preferible ser explícitos y colocar los datos que ingresaría el usuario.
      # Los spec son la documentación de la aplicación, en este caso no nos interesa DRY.
      # Por ello no uso:
      # contact = build(:contact)
      expect{
        click_link 'New Contact'
        fill_in 'Firstname', with: 'Emanuel'
        fill_in 'Lastname', with: 'Alarcón'
        fill_in 'Email', with: 'emanuel.cadems@gmail.com'
        fill_in 'home', with: '0387-4-228891'
        fill_in 'office', with: '0800-888-7891'
        fill_in 'mobile', with: '0381-154-693748'
        click_button 'Create Contact'
      }.to change(Contact, :count).by(1)
      page.should have_content 'Contact was successfully created.'
      page.should have_content 'Emanuel Alarcón'
      page.should have_content 'home 0387-4-228891'
      page.should have_content 'office 0800-888-7891'
      page.should have_content 'mobile 0381-154-693748'
    end

    it "edits contact", :emanuel => true do
      contact = create(:contact, 
          firstname: 'Ema', 
          lastname: 'Al',
          email: 'e@gmail.com')
      visit root_path
      within "#contact_#{contact.id}" do
        click_link "Edit"
      end
      fill_in 'Firstname', with: 'Emanuel'
      fill_in 'Lastname', with: 'Alarcon'
      fill_in 'Email', with: 'emanuel_cadems@hotmail.com'
      fill_in 'home', with: '0387-4-228891'
      fill_in 'office', with: '0387-4-228891'
      fill_in 'mobile', with: '0381-154-693748'
      click_button 'Update Contact'
      save_and_open_page
      page.should have_content 'Emanuel Alarcon'
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
  end
end



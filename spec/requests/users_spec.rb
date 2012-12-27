require 'spec_helper'

describe 'User management' do
  it "adds a new user" do
    admin = create(:admin)
    sign_in admin
    
    expect{
      click_link 'Users'
      click_link 'New User'
      fill_in 'Email', with: 'e@gmail.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '123456'
      click_button 'Create User'
    }.to change(User, :count).by(1)

    current_path.should eq users_path
    page.should have_content 'New user created.'
    within 'h1' do
      page.should have_content 'Users'
    end
    page.should have_content 'e@gmail.com'
  end
end
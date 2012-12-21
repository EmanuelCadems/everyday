require 'spec_helper'
describe Phone do
  it "allows two contact to share a phone number" do
    create(:work_phone, 
      phone:'789-555-1234')
    build(:work_phone, 
      phone:'789-555-1234').should be_valid
  end
end
require 'spec_helper'

describe Contact do
  RSpec::Matchers.define :be_named do |expected|
    match do |actual|
      actual.name == expected
    end
    description do
      "return a full name as a string"
    end
  end

  subject{create(:contact, firstname:'Emanuel', lastname:'Alarcon')}
  it {should validate_presence_of(:firstname)}
  it {should validate_presence_of(:lastname)}
  it {should validate_uniqueness_of(:email)}
  it {should be_named 'Emanuel Alarcon'}

  describe "filter by lastname that match with a letter input", :filter => true do

    let!(:lizondo) {create(:contact, firstname:'Pedro', lastname: 'Lizondo')}
    let!(:alarcon) {create(:contact, firstname:'Emanuel', lastname: 'Alarcon')}
    let!(:aciar) {create(:contact, firstname:'Daniel', lastname: 'Aciar Uncos')}

    context "matching letters" do
      it "return a sorted array of results that match" do
        Contact.by_letter("A").should eq [aciar, alarcon]
      end
    end

    context "not-matching letters" do
      it "does not return contacts that start with a differente letter" do
        Contact.by_letter("A").should_not eq [lizondo]
      end
    end
  end

  it "has three phone numbers"do
    create(:contact).phones.count.should eq 3
  end

end

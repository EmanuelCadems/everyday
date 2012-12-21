require 'spec_helper'

describe Contact do

  it "has a valid factory" do
    create(:contact).should be_valid
  end

  it "invalid without a firstname" do
    build(:contact, firstname: nil).should_not be_valid
  end

  it "invalid without a lastname" do
    build(:contact, lastname: nil).should_not be_valid
  end

  it "returns a contact's full name as a string"do
    create(:contact, firstname: 'Emanuel', lastname: 'Alarcon').name.should eq'Emanuel Alarcon'
  end

  it "invalid with an email existing" do
    create(:contact, email:'emanuel@gmail.com')
    build(:contact, email:'emanuel@gmail.com').should_not be_valid
  end

  describe "filter by lastname that match with a letter input" do

    before :each do
      @lizondo = create(:contact, firstname:'Pedro', lastname: 'Lizondo')
      @alarcon = create(:contact, firstname:'Emanuel', lastname: 'Alarcon')
      @aciar = create(:contact, firstname:'Daniel', lastname: 'Aciar Uncos')
    end

    context "matching letters" do
      it "return a sorted array of results that match" do
        Contact.by_letter("A").should eq [@aciar, @alarcon]
      end
    end

    context "not-matching letters" do
      it "does not return contacts that start with a differente letter"do
        Contact.by_letter("A").should_not eq [@lizondo]
      end
    end

  end

  it "has three phone numbers"do
    create(:contact).phones.count.should eq 3
  end

end

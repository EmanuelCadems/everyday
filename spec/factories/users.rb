require 'faker'
FactoryGirl.define do
  factory :user do
  	email {Faker::Internet.email}
  	factory :admin do
  	  password '123456'
  	  password_confirmation '123456'
  	  admin true
  	end	
  end	
end
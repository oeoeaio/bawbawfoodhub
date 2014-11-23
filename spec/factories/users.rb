require 'faker'

FactoryGirl.define do
  factory :user do
    given_name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    password { Faker::Internet.password(8,20) }
  end
end

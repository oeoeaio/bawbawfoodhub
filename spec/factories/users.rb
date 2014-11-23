require 'faker'

FactoryGirl.define do
  factory :user do
    given_name { Faker::Name.first_name }
    surname { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    pass = Faker::Internet.password
    password pass
    password_confirmation pass
  end
end

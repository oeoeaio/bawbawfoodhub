FactoryGirl.define do
  factory :sensor do
    name { Faker::App.name }
    active { true }
  end
end

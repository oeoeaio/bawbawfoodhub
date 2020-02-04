FactoryGirl.define do
  factory :sensor do
    name { Faker::App.name }
    active { true }
    identifier { Faker::Number.leading_zero_number(digits: 3) }
    alert_recipients { '+61412345678,+61412345679' }
  end
end

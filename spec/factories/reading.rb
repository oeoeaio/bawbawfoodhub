FactoryGirl.define do
  factory :reading do
    sensor
    value { rand(0.0..10.0) }
    recorded_at { Time.now }
  end
end

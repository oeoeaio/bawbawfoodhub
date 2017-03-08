FactoryGirl.define do
  factory :alert do
    sensor
    category { [:missing, :time, :value].sample }
  end
end

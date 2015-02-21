FactoryGirl.define do
  factory :rollover do
    season
    subscription
    confirmed_at Date.today.to_time
  end

end

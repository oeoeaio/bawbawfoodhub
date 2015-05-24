FactoryGirl.define do
  factory :rollover do
    season
    user
    box_size { ['small', 'standard', 'large'].sample }
    confirmed_at Date.today.to_time
  end

end

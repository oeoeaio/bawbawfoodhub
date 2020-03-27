FactoryGirl.define do
  factory :subscription do
    season
    user
    box_size "large"
    frequency "weekly"
    day_of_week "wednesday"
    delivery false
  end
end

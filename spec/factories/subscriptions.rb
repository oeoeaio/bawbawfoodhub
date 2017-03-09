FactoryGirl.define do
  factory :subscription do
    season
    user
    box_size "large"
    frequency "weekly"
    delivery false
  end
end

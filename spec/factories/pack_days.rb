FactoryGirl.define do
  factory :pack_day do
    sequence(:pack_date) { |n| Date.today + (7*n).days}
  end
end

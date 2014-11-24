FactoryGirl.define do
  factory :season do
    name "Summer 2015"
    slug { Faker::Internet.slug }
    signups_open true
    places_remaining 1
  end

end

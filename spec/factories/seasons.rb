FactoryGirl.define do
  factory :season do
    name "Summer 2015"
    slug { Faker::Internet.slug }
    signups_open true
    places_remaining 1
  end

  factory :season_with_pack_days, parent: :season do |season|
    after(:create) do |season|
      create_list(:pack_day, 3, season: season)
    end
  end

end

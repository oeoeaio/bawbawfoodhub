FactoryGirl.define do
  factory :base_season, class: Season do
    name "Summer 2015"
    slug { Faker::Internet.slug(nil, "_") }
    signups_open true
    places_remaining 1
  end

  factory :season, parent: :base_season do |season|
    after(:create) do |season|
      create_list(:pack_day, 3, season: season)
    end
  end

  factory :season_without_pack_days, parent: :base_season do |season|
  end
end

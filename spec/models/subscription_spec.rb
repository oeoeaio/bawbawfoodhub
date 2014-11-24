require 'rails_helper'

RSpec.describe Subscription, :type => :model do
  describe "validations" do
    it "box size must be from the list" do
      user = build(:user)
      season = build(:season)
      expect(Subscription.new(season: season, user: user, box_size: nil)).to be_invalid
      expect(Subscription.new(season: season, user: user, box_size: 'lala')).to be_invalid
      expect(Subscription.new(season: season, user: user, box_size: 'standard')).to be_valid
      expect(Subscription.new(season: season, user: user, box_size: 'small')).to be_valid
      expect(Subscription.new(season: season, user: user, box_size: 'large')).to be_valid
    end
  end
end

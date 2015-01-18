require 'rails_helper'

RSpec.describe Subscription, :type => :model do
  describe "validations" do
    it "box size must be from the list" do
      user = build(:user)
      season = create(:season)
      expect(Subscription.new(season: season, user: user, box_size: nil)).to be_invalid
      expect(Subscription.new(season: season, user: user, box_size: 'lala')).to be_invalid
      expect(Subscription.new(season: season, user: user, box_size: 'standard')).to be_valid
      expect(Subscription.new(season: season, user: user, box_size: 'small')).to be_valid
      expect(Subscription.new(season: season, user: user, box_size: 'large')).to be_valid
    end

    it "can only subscribe to a season with remaining pack days" do
      user = build(:user)
      season = create(:season_without_pack_days)
      expect(Subscription.new(season: season, user: user, box_size: 'small')).to be_invalid
      season.pack_days << build(:pack_day, pack_date: Date.today + 7.days)
      season.save!
      expect(Subscription.new(season: season, user: user, box_size: 'small')).to be_valid
    end

    it "can only subscribe to a season with open signups" do
      user = build(:user)
      season = create(:season, signups_open: false)
      expect(Subscription.new(season: season, user: user, box_size: 'small')).to be_invalid
      season.signups_open = true
      season.save!
      expect(Subscription.new(season: season, user: user, box_size: 'small')).to be_valid
    end
  end

  describe "emails" do
    let!(:season) { create(:season) }
    let!(:subscription) { create(:subscription, season: season) }

    it "sends a confirmation email" do
      expect { subscription.send(:send_confirmation) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end

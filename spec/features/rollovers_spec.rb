require 'rails_helper'

RSpec.describe 'Responding to rollover emails', :type => :feature do
  let!(:rollover) { create(:rollover, confirmed_at: nil) }
  let!(:token_generator_mock) { double(:token_generator) }

  before do
    allow(Devise).to receive(:token_generator) { token_generator_mock }
    allow(token_generator_mock).to receive(:digest) { rollover.confirmation_token }
  end

  describe "cancellation" do
    it "renders 'cancel' with the relevant rollover" do
      visit cancel_rollovers_path(raw_token: 'sometoken')
      expect(page).to have_content "We have cancelled your subscription for the #{rollover.season.name} season."
    end
  end

  describe "confirmation" do
    context "without a box size" do
      before do
        visit new_season_subscription_path(rollover.season, raw_token: 'sometoken')
      end

      it "renders 'new' with the relevant subscription information" do
        expect(page).to have_content "Signing up for #{rollover.season.name}"
      end
    end

    context "with a box size" do
      before do
        visit new_season_subscription_path(rollover.season, raw_token: 'sometoken', box_size: 'large' )
      end

      it "creates a new subscription based on rollover subscription" do
        expect(page).to have_content "Thanks #{rollover.user.given_name}"
        expect(page).to have_content "You are now signed up for the #{rollover.season.name} season!"
        expect(page).to have_content "We will pack you a Large Box each Tuesday"
        subscription = Subscription.last
        expect(subscription.season).to eq rollover.season
        expect(subscription.box_size).to eq 'large'
        expect(subscription.user).to eq rollover.user
      end
    end
  end
end

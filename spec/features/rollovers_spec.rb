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
    it "renders 'new' with the relevant subscription information" do
      visit new_season_subscription_url(rollover.season, raw_token: 'sometoken')
      expect(page).to have_content "Signing up for #{rollover.season.name}"
    end
  end
end

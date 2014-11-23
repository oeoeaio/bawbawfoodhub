require 'rails_helper'

RSpec.describe Season, :type => :model do
  describe "associations" do
    describe "subscriptions" do
      let(:season){ create(:season) }
      let(:subscription1) { create(:subscription, season: season) }
      let(:subscription2) { create(:subscription) }

      it "finds subscriptions for a particular season" do
        expect(season.subscriptions).to eq [subscription1]
      end
    end
  end
end

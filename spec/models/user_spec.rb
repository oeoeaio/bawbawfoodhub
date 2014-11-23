require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "associations" do
    describe "subscriptions" do
      let!(:user){ create(:user) }
      let!(:subscription1) { create(:subscription, user: user) }
      let!(:subscription2) { create(:subscription) }

      it "finds subscriptions for a user" do
        expect(user.subscriptions).to eq [subscription1]
      end
    end
  end
end

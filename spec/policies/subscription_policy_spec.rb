require 'rails_helper'
require 'pundit/rspec'

describe SubscriptionPolicy do
  subject { described_class }

  describe 'scoping' do
    describe "when given a user of User class" do
      let!(:user) { create(:user) }
      let!(:subscription1) { create(:subscription, user: user ) }
      let!(:subscription2) { create(:subscription ) }
      let!(:subscription3) { create(:subscription, user: user ) }

      it "scopes the list of subscriptions to those owned by the user" do
        expect(SubscriptionPolicy::Scope.new(user, Subscription).resolve).to include subscription1, subscription3
        expect(SubscriptionPolicy::Scope.new(user, Subscription).resolve).to_not include subscription2
      end
    end

    describe "when given a user of Admin class" do
      let!(:admin) { create(:admin) }
      let!(:subscription1) { create(:subscription ) }
      let!(:subscription2) { create(:subscription ) }
      let!(:subscription3) { create(:subscription ) }

      it "returns the whole scope" do
        expect(SubscriptionPolicy::Scope.new(admin, Subscription).resolve).to include subscription1, subscription2, subscription3
      end
    end
  end
end
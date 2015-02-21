require 'rails_helper'

RSpec.describe Admin::RolloversController, :type => :controller do
  let(:admin) { build(:admin) }
  before { allow(controller).to receive(:current_admin).and_return admin }

  describe 'create_multiple' do
    let!(:season) { create(:season) }
    let!(:original_season) { create(:season) }
    let(:subscription1) { create(:subscription, season: original_season) }
    let(:subscription2) { create(:subscription, season: original_season) }

    describe "creating rollovers" do
      it "creates a new rollover for each of the specified subscriptions" do
        expect(Rollover.all.count).to be 0
        allow_any_instance_of(Rollover).to receive(:send_confirmation_instructions)
        put :create_multiple, season_id: season, subscription_ids: "#{subscription1.id},#{subscription2.id}"
        expect(Rollover.all.count).to be 2
      end
    end

    describe "confirmation instructions and redirection" do
      let(:rollover1) { double(:rollover) }
      let(:rollover2) { double(:rollover) }
      let(:rollovers) { [rollover1, rollover2] }
      let(:subscriptions) { double(:subscriptions) }

      before do
        allow(Subscription).to receive(:where) { subscriptions }
        allow(subscriptions).to receive(:map) { rollovers }
      end

      describe "when all objects save" do
        it "sends confirmation emails and redirects" do
          rollovers.each do |r|
            rollovers.each{ |r| allow(r).to receive(:save) { true } }
            expect(r).to receive(:send_confirmation_instructions)
          end

          put :create_multiple, season_id: season, subscription_ids: "#{subscription1.id},#{subscription2.id}"
          expect(response).to redirect_to admin_season_rollovers_path(season)
        end
      end

      describe "when some objects don't save" do
        it "does not send confirmation emails and redirects back to season" do
          rollovers.each do |r|
            rollovers.each{ |r| allow(r).to receive(:save) { false } }
            expect(r).to_not receive(:send_confirmation_instructions)
          end
          put :create_multiple, season_id: season, original_season_id: original_season, subscription_ids: "#{subscription1.id},#{subscription2.id}"
          expect(response).to redirect_to admin_season_subscriptions_path(original_season)
        end
      end
    end
  end
end

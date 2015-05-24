require 'rails_helper'

RSpec.describe Admin::RolloversController, :type => :controller do
  let(:admin) { build(:admin) }
  before { allow(controller).to receive(:current_admin).and_return admin }



  describe "new" do
    it "builds a new rollover and renders :new" do
      get :new
      expect(assigns(:rollover)).to be_a_new Rollover
      expect(response).to render_template :new
    end

    context "when given a user_id" do
      let(:user) { create(:user) }
      before { get :new, user_id: user.id }

      it "sets the user on the new rollover" do
        expect(assigns(:rollover).user).to eq user
      end
    end

    context "when given a season_id" do
      let(:season) { create(:season) }
      before { get :new, season_id: season.slug }

      it "sets the season on the new rollover" do
        expect(assigns(:rollover).season).to eq season
      end
    end
  end

  describe 'create' do
    describe "redirection" do
      let(:season) { create(:season) }
      let(:rollover) { double(:rollover, season: season) }
      before do
        allow(rollover).to receive(:skip_confirmation_notification!) { true }
        allow(Rollover).to receive(:new) { rollover }
      end

      describe 'on successful save' do
        it 'redirects to index' do
          expect(rollover).to receive(:save).and_return true
          post :create, { rollover: { box_size: 'standard' } }
          expect(response).to redirect_to admin_season_rollovers_path(season)
        end
      end

      describe 'on unsuccessful save' do
        it 'returns to new' do
          expect(rollover).to receive(:save).and_return false
          post :create, { rollover: { box_size: 'standard' } }
          expect(response).to render_template :new
        end
      end
    end

    describe "on success" do
      let(:season) { create(:season) }
      let(:user) { create(:user) }
      let(:rollover_params) { { rollover: { season_id: season.id, user_id: user.id, box_size: 'large' } } }

      it "creates a new rollover" do
        expect{post :create, rollover_params}.to change{Rollover.count}.by(1)
        rollover = Rollover.last
        expect(rollover.season).to eq season
        expect(rollover.user).to eq user
        expect(rollover.box_size).to eq 'large'
      end

      it "does not send a confirmation email" do
        expect{post :create, rollover_params}.to_not change{ActionMailer::Base.deliveries.count}
      end
    end
  end

  describe 'create_multiple' do
    let!(:target_season) { create(:season) }
    let!(:original_season) { create(:season) }
    let(:subscription1) { create(:subscription, season: target_season) }
    let(:subscription2) { create(:subscription, season: target_season) }

    describe "creating rollovers" do
      it "creates a new rollover for each of the specified subscriptions" do
        expect(Rollover.all.count).to be 0
        allow_any_instance_of(Rollover).to receive(:send_confirmation_instructions)
        put :create_multiple, season_id: original_season, target_season_id: target_season, subscription_ids: [subscription1.id,subscription2.id]
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
        before do
          rollovers.each do |r|
            rollovers.each{ |r| allow(r).to receive(:save) { true } }
          end
        end

        it "doesn't send any confirmation emails" do
          subscription1
          subscription2
          expect{
            put :create_multiple, season_id: original_season, target_season_id: target_season, subscription_ids: [subscription1.id,subscription2.id]
          }.to_not change{ActionMailer::Base.deliveries.count}
        end

        it "redirects" do
          put :create_multiple, season_id: original_season, target_season_id: target_season, subscription_ids: [subscription1.id,subscription2.id]
          expect(response).to redirect_to admin_season_rollovers_path(target_season)
        end
      end

      describe "when some objects don't save" do
        it "does not send confirmation emails and redirects back to season" do
          rollovers.each do |r|
            rollovers.each{ |r| allow(r).to receive(:save) { false } }
            expect(r).to_not receive(:send_confirmation_instructions)
          end
          put :create_multiple, season_id: original_season, target_season_id: target_season, subscription_ids: [subscription1.id,subscription2.id]
          expect(response).to redirect_to admin_season_subscriptions_path(original_season)
        end
      end
    end
  end

  describe 'bulk_action' do
    let!(:target_season) { create(:season) }
    let!(:rollover) { create(:rollover) }

    describe "cancel" do
      it "cancels the rollovers submitted" do
        expect{
          post :bulk_action, season_id: target_season, bulk_action: 'cancel', rollover_ids: [rollover.id]
        }.to change{rollover.reload.cancelled?}.from(false).to(true)
        expect(flash[:success]).to eq "Cancelled 1 rollovers"
      end
    end

    describe "send" do
      it "send confirmatino emails for the rollovers submitted" do
        expect{
          post :bulk_action, season_id: target_season, bulk_action: 'send', rollover_ids: [rollover.id]
        }.to change{ActionMailer::Base.deliveries.count}.by(1)
        expect(flash[:success]).to eq "Sent 1 confirmation emails"
      end
    end
  end
end

require 'rails_helper'
require 'support/controller_auth'

RSpec.describe Admin::SubscriptionsController, :type => :controller do
  include ControllerAuth
  let!(:admin) { login_admin }
  let(:season) { create(:season) }
  let(:user) { create(:user) }

  describe "seasons_index" do
    let(:subscription1) { create(:subscription, season: season) }
    let(:subscription2) { create(:subscription) }

    before(:example) do
      get :seasons_index, params: { season_id: season.slug }
    end

    it "assigns the season" do
      expect(assigns(:season)).to eq season
    end

    it "scopes the subscriptions" do
      expect(assigns(:subscriptions)).to eq [subscription1]
    end
  end

  describe "users_index" do
    let(:subscription1) { create(:subscription, user: user) }
    let(:subscription2) { create(:subscription) }

    before(:example) do
      get :users_index, params: { user_id: user.id }
    end

    it "assigns the season" do
      expect(assigns(:user)).to eq user
    end

    it "scopes the subscriptions" do
      expect(assigns(:subscriptions)).to eq [subscription1]
    end
  end

  describe "new" do
    it "builds a new subscription and renders :new" do
      get :new
      expect(assigns(:subscription)).to be_a_new Subscription
      expect(response).to render_template :new
    end

    context "when given a user_id" do
      let(:user) { create(:user) }
      before { get :new, params: { user_id: user.id } }

      it "set the user on the new subscription" do
        expect(assigns(:subscription).user).to eq user
      end
    end

    context "when given a season_id" do
      let(:season) { create(:season) }
      before { get :new, params: { season_id: season.slug } }

      it "set the season on the new subscription" do
        expect(assigns(:subscription).season).to eq season
      end
    end
  end

  describe 'create' do
    describe "redirection" do
      let(:season) { create(:season) }
      let(:subscription) { double(:subscription, season: season) }
      before do
        allow(Subscription).to receive(:new) { subscription }
      end

      describe 'on successful save' do
        it 'redirects to index' do
          expect(subscription).to receive(:save).and_return true
          post :create, params: { subscription: { box_size: 'standard' } }
          expect(response).to redirect_to admin_season_subscriptions_path(season)
        end
      end

      describe 'on unsuccessful save' do
        it 'returns to new' do
          expect(subscription).to receive(:save).and_return false
          post :create, params: { subscription: { box_size: 'standard' } }
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'update' do
    let(:season) { create(:season) }
    let(:subscription) { double(:subscription, season: season, class: Subscription) }
    before do
      allow(Subscription).to receive(:find) { subscription }
    end

    describe 'on successful update' do
      it 'redirects to index' do
        expect(subscription).to receive(:update_attributes).and_return true
        put :update, params: { id: 1, subscription: { box_size: 'standard' } }
        expect(response).to redirect_to admin_season_subscriptions_path(season)
      end
    end

    describe 'on unsuccessful save' do
      it 'returns to edit' do
        expect(subscription).to receive(:update_attributes).and_return false
        put :update, params: { id: 1, subscription: { box_size: 'standard' } }
        expect(response).to render_template :edit
      end
    end
  end
end

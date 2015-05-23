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
      get :seasons_index, season_id: season.slug
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
      get :users_index, user_id: user.id
    end

    it "assigns the season" do
      expect(assigns(:user)).to eq user
    end

    it "scopes the subscriptions" do
      expect(assigns(:subscriptions)).to eq [subscription1]
    end
  end
end

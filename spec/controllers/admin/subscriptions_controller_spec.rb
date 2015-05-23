require 'rails_helper'
require 'support/controller_auth'

RSpec.describe Admin::SubscriptionsController, :type => :controller do
  include ControllerAuth
  let!(:admin) { login_admin }
  let(:season) { create(:season) }
  let(:subscription1) { create(:subscription, season: season) }
  let(:subscription2) { create(:subscription) }

  describe "index" do
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
end

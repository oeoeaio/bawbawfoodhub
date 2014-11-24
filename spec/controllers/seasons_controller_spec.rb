require 'rails_helper'

RSpec.describe SeasonsController, :type => :controller do
  describe 'show' do
    let(:season) { create(:season) }
    before { get :show, slug: season.slug }

    it "loads the season based on the slug" do
      expect(assigns(:season)).to eq season
    end
  end
end

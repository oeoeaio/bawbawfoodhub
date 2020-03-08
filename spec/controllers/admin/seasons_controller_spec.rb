require 'rails_helper'

RSpec.describe Admin::SeasonsController, :type => :controller do
  let(:admin) { build(:admin) }
  before { allow(controller).to receive(:current_admin).and_return admin }

  describe 'create' do
    let(:season) { double(:season) }
    before do
      allow(Season).to receive(:new) { season }
    end

    describe 'on successful save' do
      it 'redirects to index' do
        expect(season).to receive(:save!).and_return true
        post :create, params: { season: { name: 'Season 1' } }
        expect(response).to redirect_to admin_seasons_path
      end
    end

    describe 'on unsuccessful save' do
      it 'returns to new' do
        expect(season).to receive(:save!).and_return false
        post :create, params: { season: { name: 'Season 1' } }
        expect(response).to render_template :new
      end
    end
  end

  describe 'update' do
    let(:season) { double(:season, class: Season) }
    before do
      allow(Season).to receive(:find_by_slug) { season }
    end

    describe 'on successful update' do
      it 'redirects to index' do
        expect(season).to receive(:update_attributes!).and_return true
        put :update, params: { id: 1, season: { name: 'Season 1' } }
        expect(response).to redirect_to admin_seasons_path
      end
    end

    describe 'on unsuccessful save' do
      it 'returns to edit' do
        expect(season).to receive(:update_attributes!).and_return false
        put :update, params: { id: 1, season: { name: 'Season 1' } }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'populate' do
    let(:season) { Season.new(slug: 'some_season_slug') }
    let(:populator) { instance_double(SeasonPopulator, run: nil, message: 'some_message') }

    before do
      allow(Season).to receive(:find_by_slug) { season }
      allow(SeasonPopulator).to receive(:new) { populator }
      get(:populate, params: { id: 1})
    end

    it 'runs the season populator' do
      expect(populator).to have_received(:run)
    end

    it 'populates the flash message with the message from the populator' do
      expect(flash[:notice]).to eq('some_message')
    end

    it 'redirects to the pack days view' do
      expect(response).to redirect_to(admin_season_pack_days_path('some_season_slug'))
    end
  end
end

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
        post :create, { season: { id: 1 } }
        expect(response).to redirect_to admin_seasons_path
      end
    end

    describe 'on unsuccessful save' do
      it 'returns to index' do
        expect(season).to receive(:save!).and_return false
        post :create, { season: { id: 1 } }
        expect(response).to render_template :new
      end
    end
  end

  describe 'update' do
    let(:season) { double(:season, class: Season) }
    before do
      allow(Season).to receive(:find) { season }
    end

    describe 'on successful update' do
      it 'redirects to index' do
        expect(season).to receive(:update_attributes!).and_return true
        put :update, { id: 1, season: { id: 1 } }
        expect(response).to redirect_to admin_seasons_path
      end
    end

    describe 'on unsuccessful save' do
      it 'returns to index' do
        expect(season).to receive(:update_attributes!).and_return false
        put :update, { id: 1, season: { id: 1 } }
        expect(response).to render_template :edit
      end
    end
  end
end
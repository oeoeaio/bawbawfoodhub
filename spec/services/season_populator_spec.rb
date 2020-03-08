require 'rails_helper'

RSpec.describe SeasonPopulator do
  subject(:populator) { described_class.new(season: season) }

  let(:today) { Date.today }
  let(:tuesday) { today + (2 - today.wday) }
  let(:wednesday) { tuesday + 1 }
  let(:ends_on) { tuesday + 28 }

  context 'when the season has no pack days' do
    let(:season) { create(:season_without_pack_days, starts_on: starts_on, ends_on: ends_on) }

    context 'when starts_on is not a tuesday' do
      let(:starts_on) { wednesday }

      it 'does not create any pack days' do
        expect{ populator.run }.not_to change(season.pack_days, :count)
      end

      it 'message returns an error' do
        expect{ populator.run }.to change(populator, :message).to(
          'Season does not start on a Tuesday'
        )
      end
    end

    context 'when starts_on is a tuesday' do
      let(:starts_on) { tuesday }

      it 'creates one pack day per tuesday between starts_on and ends_on inclusive' do
        expect{ populator.run }.to change(season.pack_days, :count).by(5)
      end

      it 'message communicates how many pack days were created' do
        expect{ populator.run }.to change(populator, :message).to(
          /Added 5 pack days to #{season.name}/
        )
      end
    end
  end

  context 'when the season already has some pack days' do
    let(:season) { create(:season, starts_on: Date.today) }

    it 'does not create any pack days' do
      expect{ populator.run }.not_to change(season.pack_days, :count)
    end

    it 'message is an error' do
      expect{ populator.run }.to change(populator, :message).to(
        'Season already has pack days'
      )
    end
  end
end

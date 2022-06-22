require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'current_season' do
    let(:autumn) { create(:season_without_pack_days, name: "Autumn", created_at: Date.yesterday.to_time )}
    let(:winter) { create(:season_without_pack_days, name: "Winter", created_at: Date.today.to_time )}
    let(:spring) { create(:season_without_pack_days, name: "Spring", created_at: Date.tomorrow.to_time )}

    let!(:autumn_pd) { create(:pack_day, season: autumn, pack_date: Date.new(2015,3,1)) }
    let!(:winter_pd1) { create(:pack_day, season: winter, pack_date: Date.new(2015,6,1)) }
    let!(:winter_pd2) { create(:pack_day, season: winter, pack_date: Date.new(2015,6,8)) }
    let!(:spring_pd) { create(:pack_day, season: spring, pack_date: Date.new(2015,9,1)) }

    describe "when current date is before first pack day in the system" do
      before { allow(Time).to receive(:now) { Date.new(2014,1,1).to_time } }
      it "returns the season with the earliest pack day" do
        expect(current_season).to eq autumn
      end
    end

    describe "when current date between the last pack day of one season and the first of another" do
      before { allow(Time).to receive(:now) { Date.new(2015,04,01).to_time } }
      it "returns the next season with the earliest pack day" do
        expect(current_season).to eq winter
      end
    end

    describe "when current date is between the first and last pack days of a season" do
      before { allow(Time).to receive(:now) { Date.new(2015,6,4).to_time } }
      it "returns that season" do
        expect(current_season).to eq winter
      end
    end

    describe "when current date is after last pack day in the system" do
      before { allow(Time).to receive(:now) { Date.new(2016,1,1).to_time } }
      it "returns the season that was created last" do
        expect(current_season).to eq spring
      end
    end
  end
end

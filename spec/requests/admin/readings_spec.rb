require 'rails_helper'

RSpec.describe 'admin readings', :type => :request do
  let(:admin) { create(:admin) }
  let(:sensor) { create(:sensor) }

  before do
    sign_in admin
  end

  describe "index" do
    let!(:recent_reading) { create(:reading, sensor: sensor, recorded_at: 5.days.ago) }
    let!(:old_reading) { create(:reading, sensor: sensor, recorded_at: 1.year.ago) }
    let!(:very_old_reading) { create(:reading, sensor: sensor, recorded_at: 3.years.ago) }
    let(:params) { { sensor_id: sensor.id } }

    before do
      get admin_sensor_readings_path(params)
    end

    context 'when no since parameter is specified' do
      it 'only displays recent readings' do
        expect(response.body).to include(recent_reading.value.to_s)
        expect(response.body).not_to include(old_reading.value.to_s)
        expect(response.body).not_to include(very_old_reading.value.to_s)
      end
    end

    context 'when a since parameter is specified' do
      let(:params) { super().merge(since: 2.years.ago.strftime('%F')) }

      it 'displays readings since the specified date' do
        expect(response.body).to include(recent_reading.value.to_s)
        expect(response.body).to include(old_reading.value.to_s)
        expect(response.body).not_to include(very_old_reading.value.to_s)
      end
    end
  end
end

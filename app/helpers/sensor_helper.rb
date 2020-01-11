module SensorHelper
  def last_reading_summary_for_sensor(sensor)
    return unless sensor.last_reading
    "#{sensor.last_reading.value}°C - #{time_ago_in_words(sensor.last_reading.recorded_at)} ago"
  end
end

class SensorChecker
  def self.run
    count = Sensor.count
    Rails.logger.info "Found #{count} sensor(s)!"
  end
end

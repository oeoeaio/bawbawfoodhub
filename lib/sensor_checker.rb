class SensorChecker
  include ActionView::Helpers::DateHelper

  def self.start
    checker = SensorChecker.new
    checker.run
  end

  def run
    Sensor.active.each do |sensor|
      reading = sensor.last_reading

      if reading.present?
        recover_from(:missing, sensor)
      else
        next send_alert(:missing, sensor, reading)
      end

      if reading.recorded_at > 2.hours.ago
        recover_from(:time, sensor)
      else
        next send_alert(:time, sensor, reading)
      end

      if reading.value.between?(sensor.lower_limit, sensor.upper_limit)
        recover_from(:value, sensor)
      else
        next if pack_day_in_progress?
        send_alert(:value, sensor, reading)
      end
    end
  end

  private

  def pack_day_in_progress?
    return unless PackDay.where(pack_date: Date.today).any?
    Time.now.between?(Date.today + 11.hours, Date.today + 19.hours)
  end

  def body_for(category, sensor, reading)
    case category
    when :missing
      "No readings recorded yet for #{sensor.name}"
    when :time
      "Last reading for #{sensor.name} was #{time_ago_in_words(reading.recorded_at)} ago"
    when :value
      "Last reading for #{sensor.name} (#{reading.value}) was outside of range. [#{sensor.lower_limit} - #{sensor.upper_limit}]"
    else
      "There is a problem with #{sensor.name}"
    end
  end

  def last_alert_for(category, sensor)
    sensor.alerts.current.where(category: category).last
  end

  def recover_from(category, sensor)
    alert = last_alert_for(category, sensor)
    return unless alert.present?
    alert.update_attributes(resolved_at: Time.now)
  end

  def send_alert(category, sensor, reading)
    alert = last_alert_for(category, sensor)
    return if alert.try(&:recent_or_sleeping?)

    body = body_for(category, sensor, reading)
    body = "ESCALATION: " + body if alert.present?
    Alert.create(sensor: sensor, category: category) unless alert.present?
    recipients.each do |recipient|
      sms_client.messages.create(from: 'BBFHMonitor', to: recipient, body: body)
    end
  end

  def recipients
    Rails.application.secrets.twilio_numbers.split(",")
  end

  def sms_client
    return @sms_client unless @sms_client.nil?
    @sms_client = Twilio::REST::Client.new
  end
end

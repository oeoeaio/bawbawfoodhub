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
        next unless sensor.fail_count_reached?
        send_alert(:value, sensor, reading)
      end
    end
  end

  private

  def body_for(category, sensor, reading)
    case category
    when :missing
      "No readings recorded yet for #{sensor.name}"
    when :time
      "Last reading for #{sensor.name} was #{time_ago_in_words(reading.recorded_at)} ago"
    when :value
      n = sensor.fail_count_for_value_alert
      last_n_readings = sensor.last_n_readings(n).map(&:value).join(", ")
      if n == 1
        "Last reading for #{sensor.name} (#{reading.value}) was outside of range. [#{sensor.lower_limit} - #{sensor.upper_limit}]"
      else
        "Last #{n} readings for #{sensor.name} (#{last_n_readings}) were outside of range. [#{sensor.lower_limit} - #{sensor.upper_limit}]"
      end
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
    alert.update(resolved_at: Time.now)
  end

  def send_alert(category, sensor, reading)
    alert = last_alert_for(category, sensor)
    return if alert.try(&:recent_or_sleeping?)

    body = body_for(category, sensor, reading)
    body = "ESCALATION: " + body if alert.present?
    Alert.create(sensor: sensor, category: category) unless alert.present?
    recipients_for(sensor).each do |recipient|
      sms_client.messages.create(from: 'BBFHMonitor', to: recipient, body: body)
    end
    SensorMailer.alert(sensor, body).deliver_now if alert.present?
  rescue Twilio::REST::TwilioError => e
    body += "\n\n<br><br>There was an error sending an SMS via Twilio:"
    body += "\n\n<br><br>#{e.message}"
    SensorMailer.alert(sensor, body).deliver_now
  end

  def recipients_for(sensor)
    sensor.alert_recipients.split(",")
  end

  def sms_client
    return @sms_client unless @sms_client.nil?
    @sms_client = Twilio::REST::Client.new
  end
end

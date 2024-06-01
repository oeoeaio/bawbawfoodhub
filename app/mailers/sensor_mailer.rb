class SensorMailer < ActionMailer::Base
  def alert(sensor, message)
    @sensor = sensor
    @message = message
    mail(
      to: Rails.application.secrets.admin_email,
      from: Rails.application.secrets.admin_email,
      subject: "Alert for sensor: #{@sensor.name}"
    )
  end
end

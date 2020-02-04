class AddAlertRecipientsToSensors < ActiveRecord::Migration[5.2]
  def change
    add_column :sensors, :alert_recipients, :string

    Sensor.find_each do |sensor|
      sensor.update!(alert_recipients: Rails.application.secrets.twilio_numbers)
    end

    change_column_null :sensors, :alert_recipients, false
  end
end

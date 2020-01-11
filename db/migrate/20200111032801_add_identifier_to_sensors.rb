class AddIdentifierToSensors < ActiveRecord::Migration[5.2]
  def change
    add_column :sensors, :identifier, :string

    Sensor.find_each do |sensor|
      sensor.update!(identifier: sprintf('%03d', sensor.id))
    end

    change_column_null :sensors, :identifier, false
    add_index :sensors, :identifier, unique: true
  end
end

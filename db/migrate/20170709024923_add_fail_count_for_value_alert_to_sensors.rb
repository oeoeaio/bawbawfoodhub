class AddFailCountForValueAlertToSensors < ActiveRecord::Migration[4.2]
  def change
    add_column :sensors, :fail_count_for_value_alert, :integer, default: 1
  end
end

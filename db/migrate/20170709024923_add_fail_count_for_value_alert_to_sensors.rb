class AddFailCountForValueAlertToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :fail_count_for_value_alert, :integer, default: 1
  end
end

class AddUpperLimitAndLowerLimitToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :lower_limit, :decimal, precision: 5, scale: 1, default: 0.0
    add_column :sensors, :upper_limit, :decimal, precision: 5, scale: 1, default: 100.0
  end
end

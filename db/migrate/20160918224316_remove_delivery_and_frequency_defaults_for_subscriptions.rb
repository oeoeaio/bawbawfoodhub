class RemoveDeliveryAndFrequencyDefaultsForSubscriptions < ActiveRecord::Migration[4.2]
  def up
    change_column_default :subscriptions, :frequency, nil
    change_column_default :subscriptions, :delivery, nil
  end

  def down
    change_column_default :subscriptions, :frequency, 'weekly'
    change_column_default :subscriptions, :delivery, false
  end
end

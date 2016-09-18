class RemoveDeliveryAndFrequencyDefaultsForSubscriptions < ActiveRecord::Migration
  def up
    change_column_default :subscriptions, :frequency, nil
    change_column_default :subscriptions, :delivery, nil
  end

  def down
    change_column_default :subscriptions, :frequency, 'weekly'
    change_column_default :subscriptions, :delivery, false
  end
end

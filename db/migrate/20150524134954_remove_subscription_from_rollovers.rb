class RemoveSubscriptionFromRollovers < ActiveRecord::Migration[4.2]
  def change
    remove_column :rollovers, :subscription_id
  end
end

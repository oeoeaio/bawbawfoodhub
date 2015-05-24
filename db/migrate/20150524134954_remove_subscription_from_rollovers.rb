class RemoveSubscriptionFromRollovers < ActiveRecord::Migration
  def change
    remove_column :rollovers, :subscription_id
  end
end

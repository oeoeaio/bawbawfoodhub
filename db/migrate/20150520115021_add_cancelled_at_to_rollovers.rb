class AddCancelledAtToRollovers < ActiveRecord::Migration[4.2]
  def change
    add_column :rollovers, :cancelled_at, :datetime
  end
end

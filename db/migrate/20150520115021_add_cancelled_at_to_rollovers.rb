class AddCancelledAtToRollovers < ActiveRecord::Migration
  def change
    add_column :rollovers, :cancelled_at, :datetime
  end
end

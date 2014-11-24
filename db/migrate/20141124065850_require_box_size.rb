class RequireBoxSize < ActiveRecord::Migration
  def change
    change_column :subscriptions, :box_size, :string, null: false, default: ''
  end
end

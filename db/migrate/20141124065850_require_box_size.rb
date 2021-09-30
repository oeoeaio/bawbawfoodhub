class RequireBoxSize < ActiveRecord::Migration[4.2]
  def change
    change_column :subscriptions, :box_size, :string, null: false, default: ''
  end
end

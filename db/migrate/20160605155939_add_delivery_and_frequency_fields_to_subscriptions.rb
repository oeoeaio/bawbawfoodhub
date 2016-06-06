class AddDeliveryAndFrequencyFieldsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :frequency, :string, null: false, default: 'weekly'
    add_column :subscriptions, :delivery, :boolean, null: false, default: false
    add_column :subscriptions, :street_address, :string
    add_column :subscriptions, :town, :string
    add_column :subscriptions, :postcode, :string
  end
end

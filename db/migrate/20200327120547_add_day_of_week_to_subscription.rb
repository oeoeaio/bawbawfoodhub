class AddDayOfWeekToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :day_of_week, :string

    Subscription.update_all(day_of_week: :tuesday)

    change_column_null :subscriptions, :day_of_week, false
  end
end

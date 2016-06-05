class CreateFaqGroups < ActiveRecord::Migration
  def change
    create_table :faq_groups do |t|
      t.string :title, null: false

      t.timestamps null: false
    end
  end
end

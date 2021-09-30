class CreateFaqGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :faq_groups do |t|
      t.string :title, null: false

      t.timestamps null: false
    end
  end
end

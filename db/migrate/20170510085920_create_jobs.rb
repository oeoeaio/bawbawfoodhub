class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.string :slug, null: false, index: true
      t.datetime :closes_at, null: false
      t.text :description, null: false
      t.timestamps null: false
    end
  end
end

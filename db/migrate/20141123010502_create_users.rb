class CreateUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :users do |t|
      t.string :given_name
      t.string :surname
      t.string :email
      t.string :phone
      t.string :password

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end

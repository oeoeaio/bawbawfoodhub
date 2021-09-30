class CreateFaqs < ActiveRecord::Migration[4.2]
  def change
    create_table :faqs do |t|
      t.belongs_to :faq_group, index: true, null: false
      t.string :question, null: false
      t.text :answer, null: false

      t.timestamps null: false
    end
  end
end

class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.references :user
      t.references :category_group
      t.string :name
      t.integer :position
      t.boolean :debit
      t.boolean :credit
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

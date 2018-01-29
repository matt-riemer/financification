class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.references :user
      t.string :name
      t.string :heading
      t.integer :position
      t.boolean :debit, default: false
      t.boolean :credit, default: false
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

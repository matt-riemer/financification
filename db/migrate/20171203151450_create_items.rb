class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :account
      t.references :category
      t.references :rule
      t.references :import
      t.string :name
      t.date :date
      t.integer :debit
      t.integer :credit
      t.integer :balance
      t.text :note
      t.text :original
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

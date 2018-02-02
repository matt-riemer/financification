class CreateRules < ActiveRecord::Migration[5.1]
  def change
    create_table :rules do |t|
      t.references :category
      t.references :import
      t.references :user

      t.string :title

      t.boolean :match_name
      t.string :name

      t.boolean :match_note
      t.string :note

      t.boolean :match_price
      t.integer :price_min
      t.integer :price_max

      t.boolean :match_date
      t.datetime :start_at
      t.datetime :end_at

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

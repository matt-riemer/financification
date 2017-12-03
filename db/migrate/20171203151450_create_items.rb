class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.references :account
      t.references :source
      t.string :name
      t.datetime :date
      t.integer :amount
      t.text :note
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

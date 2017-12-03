class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.references :user
      t.string :name
      t.string :category
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

class CreateRules < ActiveRecord::Migration[5.1]
  def change
    create_table :rules do |t|
      t.references :category
      t.references :import
      t.references :user
      t.string :name_includes
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

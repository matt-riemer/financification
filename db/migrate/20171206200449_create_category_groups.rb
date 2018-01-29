class CreateCategoryGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :category_groups do |t|
      t.references :user
      t.string :name
      t.integer :position
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

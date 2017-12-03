class CreateSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.string :name
      t.string :category
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

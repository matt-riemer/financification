class CreateImports < ActiveRecord::Migration[5.1]
  def change
    create_table :imports do |t|
      t.references :account
      t.text :content
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end

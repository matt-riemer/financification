class AddStatusToImports < ActiveRecord::Migration[5.1]
  def change
    add_column :imports, :status, :string
  end
end

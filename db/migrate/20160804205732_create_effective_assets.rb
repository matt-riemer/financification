class CreateEffectiveAssets < ActiveRecord::Migration[4.2]
  def self.up
    create_table :assets do |t|
      t.string  :title
      t.text    :extra

      t.integer :user_id

      t.string  :content_type
      t.text    :upload_file
      t.string  :data
      t.boolean :processed, :default => false
      t.string  :aws_acl, :default => 'public-read'

      t.integer :data_size
      t.integer :height
      t.integer :width
      t.text    :versions_info

      t.timestamps
    end

    add_index :assets, :content_type
    add_index :assets, :user_id

    create_table :attachments do |t|
      t.integer :asset_id
      t.string  :attachable_type
      t.integer :attachable_id
      t.integer :position
      t.string  :box
    end

    add_index :attachments, :asset_id
    add_index :attachments, [:attachable_type, :attachable_id]
    add_index :attachments, :attachable_id
  end

  def self.down
    drop_table :assets
    drop_table :attachments
  end
end

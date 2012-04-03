class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :owner_id
      t.string :bio
      t.boolean :active
      t.string :group_name
      t.string   "avatar_file_name"
      t.string   "avatar_content_type"
      t.integer  "avatar_file_size"
      t.datetime "avatar_updated_at"
      t.boolean :admin_approval
      t.boolean :privacy_open
      t.boolean :privacy_closed
      t.boolean :privacy_secret

      t.timestamps
    end
  end
end

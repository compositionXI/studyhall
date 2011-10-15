class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :offering_id
      t.text :text
      t.integer :notebook_id
      t.integer :study_session_id
      t.string :upload_file_name
      t.string :upload_content_type
      t.string :upload_file_size
      t.string :upload_updated_at

      t.timestamps
    end
  end
end

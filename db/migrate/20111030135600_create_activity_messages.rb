class CreateActivityMessages < ActiveRecord::Migration
  def change
    create_table :activity_messages do |t|
      t.integer :user_id
      t.text :body

      t.timestamps
    end
  end
end

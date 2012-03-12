class CreateBroadcasts < ActiveRecord::Migration
  def change
    create_table :broadcasts do |t|
      t.string :user_id
      t.string :message
      t.string :intent
      t.string :args

      t.timestamps
    end
  end
end

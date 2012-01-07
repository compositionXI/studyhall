class AddActivistIdToActivityMessages < ActiveRecord::Migration
  def change
    add_column :activity_messages, :activist_id, :integer
  end
end

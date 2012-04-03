class AddCurrentToBroadcasts < ActiveRecord::Migration
  def change
    add_column :broadcasts, :current, :boolean
  end
end

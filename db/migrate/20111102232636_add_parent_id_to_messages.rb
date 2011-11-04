class AddParentIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :parent_id, :integer
  end
end

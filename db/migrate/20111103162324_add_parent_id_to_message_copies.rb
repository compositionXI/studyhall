class AddParentIdToMessageCopies < ActiveRecord::Migration
  def change
    add_column :message_copies, :parent_id, :integer
  end
end

class AddShareableToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :shareable, :boolean, :default => 0
  end
end

class SetShareableDefault < ActiveRecord::Migration
  def up
    change_column :notes, :shareable, :boolean, :default => true
    change_column :notebooks, :shareable, :boolean, :default => true
  end

  def down
    change_column :notes, :shareable, :boolean, :default => false
    change_column :notebooks, :shareable, :boolean, :default => false
  end
end

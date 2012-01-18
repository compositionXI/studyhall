class AddShareableToNotebooks < ActiveRecord::Migration
  def change
    add_column :notebooks, :shareable, :boolean, :default => 0
  end
end

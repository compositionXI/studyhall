class AddSlugToOfferings < ActiveRecord::Migration
  def change
    add_column :offerings, :slug, :string
    add_index :offerings, :slug, :unique => true
  end
end

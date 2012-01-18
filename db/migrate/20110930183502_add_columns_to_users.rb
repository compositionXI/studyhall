class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :custom_url, :string
    add_column :users, :bio, :text
  end
end

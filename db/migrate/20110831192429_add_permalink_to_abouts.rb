class AddPermalinkToAbouts < ActiveRecord::Migration
  def change
    add_column :abouts, :permalink, :string
  end
end

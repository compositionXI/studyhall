class AddReportedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :reported, :boolean
  end
end

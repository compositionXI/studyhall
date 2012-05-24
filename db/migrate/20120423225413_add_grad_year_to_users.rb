class AddGradYearToUsers < ActiveRecord::Migration
  def change
    add_column :users, :grad_year, :integer
  end
end

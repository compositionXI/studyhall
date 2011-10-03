class ChangeSchoolFromStirngToIntegerInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :school, :school_id
    change_column :users, :school_id, :integer
  end

  def self.down
    rename_column :users, :school_id, :school
    change_column :users, :school, :string
  end
end

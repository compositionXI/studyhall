class AddYearToTerms < ActiveRecord::Migration
  def change
    add_column :terms, :year, :integer
  end
end

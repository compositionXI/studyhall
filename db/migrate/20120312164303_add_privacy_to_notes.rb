class AddPrivacyToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :private, :boolean
    add_column :notes, :share_all, :boolean
    add_column :notes, :share_school, :boolean
    add_column :notes, :share_choice, :boolean
  end
end

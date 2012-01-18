class AddCustomCssFlagToWhiteboards < ActiveRecord::Migration
  def change
    add_column :whiteboards, :custom_css, :boolean
  end
end

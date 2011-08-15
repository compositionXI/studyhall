class AddCustomCssFlagToWhiteboards < ActiveRecord::Migration
  def change
    add_column :poc_whiteboards, :custom_css, :boolean
  end
end

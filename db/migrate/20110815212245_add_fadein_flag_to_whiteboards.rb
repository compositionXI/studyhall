class AddFadeinFlagToWhiteboards < ActiveRecord::Migration
  def change
    add_column :poc_whiteboards, :fadein_js, :boolean
  end
end

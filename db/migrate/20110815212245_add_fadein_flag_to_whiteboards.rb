class AddFadeinFlagToWhiteboards < ActiveRecord::Migration
  def change
    add_column :whiteboards, :fadein_js, :boolean
  end
end

class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :title
      t.text :text
      t.string :slug
      t.timestamps
    end
  end
end

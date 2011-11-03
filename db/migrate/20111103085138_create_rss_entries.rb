class CreateRssEntries < ActiveRecord::Migration
  def change
    create_table :rss_entries do |t|
      t.string :title
      t.string :link
      t.datetime :pub_date
      t.string :guid
      t.text :description
      t.integer :school_id

      t.timestamps
    end
  end
end

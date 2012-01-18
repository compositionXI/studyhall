class RemoveRssEntryContent < ActiveRecord::Migration
  def change
    remove_column :rss_entries, :description
    remove_column :rss_entries, :guid
  end
end

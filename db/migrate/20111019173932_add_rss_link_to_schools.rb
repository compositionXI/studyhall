class AddRssLinkToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :rss_link, :string
  end
end

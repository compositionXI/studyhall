class AddRssLinkToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :rss_link, :string
    add_column :schools, :domain_name, :string
    add_column :schools, :active, :boolean
  end
end

class AddFaqsToStaticPages < ActiveRecord::Migration
  def up
    StaticPage.create(
      :title => "FAQ's",
      :slug => "faqs",
      :text => File.open("./public/static/faqs.html", "r").read
    )
  end

  def down
    StaticPage.find_by_slug('faqs').try(:destroy)
  end
end

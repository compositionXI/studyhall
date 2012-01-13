namespace :campus_news do
  desc "Get updated news stories"
  task :fetch => :environment do
    School.has_rss_link.each do |school|
      latest_rss_entry = school.rss_entries.first
      options = {
        :on_failure => lambda {|url, response_code, response_header, response_body| Rails.logger.error "fail to fetch #{url}, the response code #{response_code}, header: #{response_header}, body: #{response_body}" }
      }
      options[:if_modified_since] =  latest_rss_entry.pub_date unless latest_rss_entry.nil?

      Feedzirra::Feed.fetch_and_parse(school.rss_link, options).entries.each do |entry|
        if (latest_rss_entry && entry.published > latest_rss_entry.pub_date) || latest_rss_entry.nil?
          RssEntry.new({:school => school,
                      :title => entry.title,
                      :pub_date => entry.published,
                      :link => entry.url}).save
        end
      end
    end
  end

  desc "Remove old news stories"
  task :prune => :environment do
    School.has_rss_link.each do |school|
      rss_entries = school.rss_entries.all
      if rss_entries.count > 6 and ((DateTime.current.to_i - rss_entries[6].pub_date.to_i)/(24*60*60) > 30)
        school.rss_entries.where(["pub_date < ? ", rss_entries[5].pub_date]).delete_all
      end
    end
  end

end


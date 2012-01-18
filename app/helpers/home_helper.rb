module HomeHelper
  
  def group_entries(rss_entries)
    grouped_entries = rss_entries.group_by{|entry| entry.pub_date.to_date }
    grouped_entries.keys.sort.reverse.map{|key| grouped_entries[key] }
  end

  def day_suffix(date)
    day = date.strftime("%-d")
    return "st" if day.end_with? "1"
    return "nd" if day.end_with? "2"
    return "rd" if day.end_with? "3"
    "th"
  end

  def formatted_pub_date(date)
    return "Today" if date.to_date == Date.today
    return "Yesterday" if date.to_date == (Date.today - 1.day)
    date.strftime("%B %-d<sup>#{day_suffix(date)}</sup>").html_safe
  end
end

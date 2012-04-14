require 'date'
date1 = DateTime.new(2012,3,9)
date_string = "['#{date1.year},#{date1.month - 1},#{date1.day}'"

12.times do
  date1 += 7
  date_string += ",'#{date1.year},#{date1.month - 1},#{date1.day}'"
end

date_string += "] \n"

File.open('/home/sam/studyhall/dates_of_days', 'a') {|f| f.write(date_string) }

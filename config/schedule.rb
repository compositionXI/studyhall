# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
#set :output, "./log/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :environment, 'production'

job_type :rake,    "cd :path && RAILS_ENV=:environment rvm_trust_rvmrcs_flag=1 bundle exec rake :task --silent :output"
job_type :runner, "rvm_trust_rvmrcs_flag=1 cd :path && studyhall_rails runner -e :environment :task :output"

every 12.hour do
  rake "campus_news:fetch"
end

every 30.days do
  rake "campus_news:prune"
end

every 24.hours do
  rake "studyhall:remove_old_searches"
end

every :hour do
  runner "Recommendation.list_all"
end

every 2.hours do
	rake "sunspot:index_recently_modified"
end

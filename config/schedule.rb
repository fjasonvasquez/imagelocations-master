set :output, "#{path}/log/cron.log"

every 30.minutes do
	rake "weather"
end

every :day, :at => '12:02am' do
	rake "carrierwave:versions:generate[1]"
	rake "carrierwave:versions:generate[2]"
	rake "subscriptions:expire"
end

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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

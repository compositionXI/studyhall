require File.join(Rails.root, 'lib', 'course_offering_importer.rb')
include CourseOfferingImporter
namespace :studyhall do
  desc "Remove searches older than a month"
  task :remove_old_searches => :environment do
    Search.delete_all ["created_at < ?", 1.month.ago]
  end

  desc "Import courses from csv files"
  task :import_courses, [:path] => :environment do |task, args|
    parse_csv_file args[:path]
  end
end

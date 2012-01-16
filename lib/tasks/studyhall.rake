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

  namespace :import_courses do 
    desc "Import all course data in db/data/schools/*.csv"
    task :all => :environment do 
      Dir[File.join(Rails.root, 'db','data','schools',"*.csv")].each do |file|
        puts "**** Processing #{file}"
        parse_csv_file file
      end
    end

    desc "Find courses with no offering an insert a default offering so that it'll show up in search and Add A Course"
    task :connect_orphans => :environment do 
      na = Instructor.find_or_create_by_first_name_and_last_name("Unassigned","Professor")
      Course.all(:include => :offerings).select { |c| c.offerings.empty? }.each do |orphan|
        Offering.create(  :school_id      => orphan.school.id,
                          :course_id      => orphan.id,
                          :instructor_id  => na.id,
                          :term           => "N/A"
        )
        Rails.logger.info "Connected Course: #{orphan.school.name} - #{orphan.title}"
      end
    end
  end

  desc "Generate slugs for Offering"
  task :generate_offering_slug => :environment do
    Offering.find_each(&:save)
    ActivityMessage.find_each do |message|
      match = message.body.match(/"\/classes\/(\d*)">/)
      next if match.nil? || match[1].blank?
      offering = Offering.find_by_id match[1] 
      message.update_attribute :body, message.body.sub("/classes/#{offering_id}", "/classes/#{offering.slug}") if offering
    end
  end
end

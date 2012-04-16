namespace :sunspot do 

	desc "indexes recently modified courses, groups, notes, and users"
	task :index_recently_modified => :environment do
		three_hours_ago = Time.now - 10800

		%w(Course Group Note User).each do |klass|
			records = instance_eval(klass).where("updated_at > ?", three_hours_ago )

			Rails.logger.info "#{klass} records to index: #{records.length}"
			
			records.each do |r|
				begin
					r.index
					Rails.logger.info "indexing #{r.id}"
				rescue StandardError
					Rails.logger.error "Failed to index #{r.id}"
				end
			end
		end
	end

end
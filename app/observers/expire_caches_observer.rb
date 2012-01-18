class ExpireCachesObserver < ActiveRecord::Observer
  observe :course, :instructor, :offering
  
  
  def after_create(model)
    expire_related_caches(model)
  end
  
  def after_update(model)
    expire_related_caches(model)
  end
  
  def after_destory(model)
    expire_related_caches(model)
  end
  
  
  private
  def expire_related_caches(model)
    if model.is_a?(Course) or model.is_a?(Offering)
      school = model.school
      expire_cache_for(school)
    elsif model.is_a?(Instructor)
      model.offerings.map(&:school_id).uniq.each do |school_id|
        ActionController::Base.new.expire_fragment("school-#{school_id}-offering-course-list")
      end
    end
  end
  
  def expire_cache_for(school)
    return if school.blank?
    ActionController::Base.new.expire_fragment("school-#{school.id}-offering-course-list")
  end
end

module SearchesHelper
  def courses_list(user)
    user.offerings.map do |offering|
      link_to(offering.course.derived_name, class_path(offering))
    end.to_sentence.html_safe
  end

  def offerings_list(course)
    course.offerings.map do |offering|
      link_to(offering.instructor.try(:full_name) || 'N/A', class_path(offering))
    end
  end
end

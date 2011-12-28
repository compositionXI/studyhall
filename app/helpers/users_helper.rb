module UsersHelper
  
  def fraternity_or_sorority_label(user)
    case user.gender
    when 'Male'
      'Fraternity'
    when 'Female'
      'Sorority'
    else
      'Fraternity or Sorority'
    end
  end
  
  def vote_help_text
    "Students can up or down vote their classmates to give others an idea of how helpful they are as a study buddy."
  end
  
  def gpa_help_text
    # replace this if you got better one
    "Grade Point Average"
  end
  
  def user_protected_profile?(user, attrubute)
    User::PROTECTED_PROFILE_ATTRBUTES.include? attrubute.to_s
  end
  
  def greek_affiliation
     @user.male? ? "#{@user.fraternity}" : "#{@user.sorority}"
  end
  
  def sybling_type
    @user.male? ? "brother" : "sister"
  end
  
  def selected_courses_for(user)
    user.enrollments.collect {|e| e.offering.id}
  end
  
  def html_greek_string_for(user)
    "a #{sybling_type} #{content_tag(:span, user.frat_sororities.map(&:name).join(","), :class => 'highlight_text')}"
  end
  
  def html_school_name_for(user)
    "attends #{content_tag(:span, user.school.try(:name), :class => 'highlight_text')}"
  end
  
  def html_sports_for(user)
    "sports in #{content_tag(:span, user.sports.map(&:name).join(","), :class => 'highlight_text')}"
  end
  
  def html_major_string_for(user)
    "majors in #{content_tag(:span, user.majors.map(&:name).join(","), :class => 'highlight_text')}"
  end
  
  def html_profile_detailed_info_for(user)
    output = []
    output << html_greek_string_for(user) unless user.frat_sororities.blank?
    output << html_school_name_for(user) if user.school
    output << html_major_string_for(user) unless user.majors.blank?
    output << html_sports_for(user) unless user.sports.blank?
    output.join(', ').capitalize.html_safe if !output.empty?
  end
  
end

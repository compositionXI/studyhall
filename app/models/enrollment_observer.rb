class EnrollmentObserver < ActiveRecord::Observer
  observe :enrollment

  def after_create(enrollment)
    enrollment.user.followers.each do |user|
      message_body = ActivityRenderer.new.generate_message(user, 'course_add', :offering => enrollment.offering, :user => enrollment.user)
      ActivityMessage.create(:user => user, :body => message_body, :activist => enrollment.user)
    end
  end
end

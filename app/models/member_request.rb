class MemberRequest < ActiveRecord::Base

  def user
    User.find(self.user_id)
  end

  def group
    Group.find(self.group_id)
  end

end

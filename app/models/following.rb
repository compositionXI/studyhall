class Following < ActiveRecord::Base
  
  belongs_to :followed_user, :class_name => "User"
  belongs_to :user

  validate :no_self_following

  def no_self_following
    if followed_user_id == user_id
      errors.add :base, "Self-following is not allowed."
    end
  end

end

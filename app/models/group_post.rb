class GroupPost < ActiveRecord::Base

  belongs_to :user

  def comments
    GroupPost.where("comment_id = ? ", self.id).order("created_at ASC");
  end

end

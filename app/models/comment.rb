class Comment < Post

  after_create :send_notifications


  def send_notifications
    author = parent.user
    Notifier.new_comment(self, user, author, parent).deliver if author.notify_on_comment? and author != user
  end

end

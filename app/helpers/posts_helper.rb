module PostsHelper
  
  def notebooks_for(posts)
    posts.collect{|p| p.notebook}.delete_if{|n| n == nil}
  end
  
  def studyhalls_for(posts)
    posts.collect{|p| p.study_session}.delete_if{|s| s == nil}
  end
end

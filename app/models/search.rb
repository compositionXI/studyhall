class Search < ActiveRecord::Base
  belongs_to :user
  
  def users
    @users ||= find_users
  end
  
  def users_count
    users.results.size
  end
  
  def any?
    size > 0
  end

  def size
    users_count + courses_count + notes_count
  end  

  def first_group
    return "people" if users.results.any?
    return "courses" if courses.results.any?
    return "notes" if notes.results.any?
  end

  private

  def find_users
    User.search do
      fulltext keywords
      order_by :name, :asc
      paginate :page => 1, :per_page => 10
    end
  end
  
  def find_courses
    Course.search do
      fulltext keywords
      paginate :page => 1, :per_page => 10
    end
  end

  def find_notes
    Note.search do
      fulltext keywords
      with :shareable, 1
      paginate :page => 1, :per_page => 10
    end
  end
  
end
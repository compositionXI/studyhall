class Search < ActiveRecord::Base
  belongs_to :user
  
  def users
    @users ||= find_users(keywords)
  end
  
  def courses
    @courses ||= find_courses(keywords)
  end
  
  def notes
    @notes ||= find_notes(keywords)
  end
  
  def users_count
    users.results.size
  end
  
  def courses_count
    courses.results.size
  end
  
  def notes_count
    notes.results.size
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

  def find_users(query='')
    User.search do
      keywords query
      order_by :name, :asc
      paginate :page => 1, :per_page => 10
    end
  end
  
  def find_courses(query='')
    Course.search do
      fulltext query
      paginate :page => 1, :per_page => 10
    end
  end

  def find_notes(query='')
    Note.search do
      fulltext query
      with :shareable, 1
      paginate :page => 1, :per_page => 10
    end
  end
  
end
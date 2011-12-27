class Search < ActiveRecord::Base
  belongs_to :user
  
  def users(page=nil)
    find_users(keywords, page)
  end
  
  def courses(page=nil)
    find_courses(keywords, page)
  end
  
  def notes(page=nil)
    find_notes(keywords, page)
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

  def find_users(query='', page)
    User.search do
      keywords query
      order_by :name, :asc
      paginate :page => page, :per_page => APP_CONFIG['per_page'] if page
    end
  end
  
  def find_courses(query='', page)
    Course.search do
      fulltext query
      paginate :page => page, :per_page => APP_CONFIG['per_page'] if page
    end
  end

  def find_notes(query='', page)
    Note.search do
      fulltext query
      with :shareable, 1
      paginate :page => page, :per_page => APP_CONFIG['per_page'] if page
    end
  end
  
  class << self
    
    def autocomplete(query='', page=1)
      Sunspot.search Note, Course, User do
        fulltext query
        with :shareable, 1
        paginate :page => page, :per_page => 5
      end
    end
    
  end
end

class Search
  
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :query, :results, :models

  def initialize(options={})
    self.results = Results.new
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
  end

  def process(options)
    if models.blank?
      results.users = find_users
      results.courses = find_courses
      results.notes = find_notes
    else
      models.split(",").each do |model|
        results.send("#{model}s=", send("find_#{model}s"))
      end
    end
  end

  def persisted?
    false
  end

  def find_users
    User.search do
      keywords query
      order_by :name, :asc
      paginate :page => 1, :per_page => 10
    end
  end

  def find_courses
    Course.search do
      fulltext query
      paginate :page => 1, :per_page => 10
    end
  end

  def find_notes
    Note.search do
      fulltext query
      with :shareable, 1
      paginate :page => 1, :per_page => 10
    end
  end

end

class Results

  attr_accessor :users, :courses, :notes

  def initialize
    self.users = []
    self.courses = []
    self.notes = []
  end

  def any?
    (users.size + courses.size + notes.size) > 0
  end

  def size
    users.size + courses.size + notes.size
  end

  def first_group
    return "people" if users.results.any?
    return "courses" if courses.results.any?
    return "notes" if notes.results.any?
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

end

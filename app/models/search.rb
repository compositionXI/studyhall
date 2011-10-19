class Search
  
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :query, :results

  def initialize(options={})
    self.results = Results.new
    options ||= {}
    options.each_pair do |key,value|
      key = "#{key}="
      self.send(key,value) if self.respond_to? key
    end
  end

  def process(options)
    results.users = find_people
    results.courses = find_courses
    results.notes = find_notes
  end

  def persisted?
    false
  end

  def find_people
    User.search do
      fulltext query
      order_by :plusminus
    end
  end

  def find_courses
    Course.search do
      fulltext query
    end
  end

  def find_notes
    Note.search do
      fulltext query
      with :shareable, 1
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

class School < ActiveRecord::Base
  
  has_many :courses
  has_many :offerings
  has_many :course_offering_imports
  has_many :users
  has_many :rss_entries
  
  validates_presence_of :name
  validates_uniqueness_of :name 
  
  scope :has_rss_link, where("rss_link IS NOT NULL")

  def latest_news
    rss_entries.limit(10).all
  end
  def self.from_email(email)
    domain = email.split("@")[1] rescue nil
    found_school = School.find_by_domain_name(domain)
    return found_school if found_school
    if Rails.env.development? || Rails.env.staging?
      School.last
    else
      nil
    end
  end
end

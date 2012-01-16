class School < ActiveRecord::Base
  
  has_many :courses
  has_many :offerings
  has_many :course_offering_imports
  has_many :users
  has_many :rss_entries
  
  scope :active_schools, where(:active => true)
  scope :inactive_schools, where(:active => false)
  
  validates_presence_of :name
  validates_uniqueness_of :name 
  
  scope :has_rss_link, where("rss_link IS NOT NULL")

  def latest_news
    rss_entries.limit(10).all
  end
  
  def self.from_email(email)
    domain = email.split("@")[1] rescue nil
    if (Rails.env.development? || Rails.env.test? || Rails.env.staging?) and (domain == "intridea.com" || domain == "studyhall.com")
      School.active_schools.first
    elsif (active_school = School.active_schools.find_by_domain_name(domain))
      active_school
    elsif (inactive_school = School.inactive_schools.find_by_domain_name(domain))
      inactive_school
    elsif domain.is_a?(String) and domain.include?(".edu")
      inactive_school = School.inactive_schools.create!(:name => "Inactive School - #{domain}", :domain_name => domain)
    else
      nil
    end
  end
end

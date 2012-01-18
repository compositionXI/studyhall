class Extracurricular < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  validates_uniqueness_of :name 
  validates_presence_of :name
  
  def self.search(term)
    items = []
    self.all.each do |e|
      items << e if e.name.include? term
    end
    items
  end
end

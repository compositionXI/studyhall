class RssEntry < ActiveRecord::Base
  default_scope :order => "pub_date DESC"

  belongs_to :school
end

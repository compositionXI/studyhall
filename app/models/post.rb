class Post < ActiveRecord::Base
  belongs_to :offering
  belongs_to :user
  belongs_to :notebook
  belongs_to :study_session
end

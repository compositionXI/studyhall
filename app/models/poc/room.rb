class Poc::Room < ActiveRecord::Base
  set_table_name :rooms
  belongs_to :poc_study_session
end

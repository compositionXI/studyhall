class Poc::StudySession < ActiveRecord::Base
   has_one :poc_room
   has_one :poc_whiteboard
end

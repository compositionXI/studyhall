class Poc::Whiteboard < ActiveRecord::Base
  set_table_name :poc_whiteboards

  OPTIONAL_COMPONENTS = %w{chat invite profile voice welcome url etherpad documents images bottomtray email widgets math logo}
end

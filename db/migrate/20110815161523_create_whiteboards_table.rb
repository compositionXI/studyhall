class CreateWhiteboardsTable < ActiveRecord::Migration
  def up
    create_table :poc_whiteboards do |t|
      t.string :session_identifier
      Poc::Whiteboard::OPTIONAL_COMPONENTS.each do |component|
        t.boolean "#{component}_component"
      end
    end
  end

  def down
    drop_table :poc_whiteboards
  end
end

class Poc::Whiteboard < ActiveRecord::Base
  set_table_name :poc_whiteboards

  OPTIONAL_COMPONENTS = %w{chat invite profile voice etherpad documents images bottomtray email widgets math}
end

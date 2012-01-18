class CreateWhiteboardsTable < ActiveRecord::Migration
  def up
    create_table :whiteboards do |t|
      t.string :session_identifier
      Whiteboard::OPTIONAL_COMPONENTS.each do |component|
        t.boolean "#{component}_component"
      end
    end
  end

  def down
    drop_table :whiteboards
  end
end

class Whiteboard < ActiveRecord::Base
  set_table_name :whiteboards

  OPTIONAL_COMPONENTS = %w{chat invite profile voice etherpad documents images bottomtray email widgets math}
end

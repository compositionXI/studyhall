class ChangeWhiteboardColumns < ActiveRecord::Migration
  def up
    Whiteboard::OPTIONAL_COMPONENTS.each do |optional|
      remove_column :whiteboards, "#{optional}_component"
    end
    remove_column :whiteboards, :custom_css
    remove_column :whiteboards, :fadein_js

    add_column :whiteboards, :document_uuid, :string
    add_column :whiteboards, :study_session_id, :integer
  end

  def down
    Whiteboard::OPTIONAL_COMPONENTS.each do |optional|
      add_column :whiteboards, "#{optional}_component", :boolean
    end
    add_column :whiteboards, :custom_css, :boolean
    add_column :whiteboards, :fadein_js, :boolean

    remove_column :whiteboards, :document_uuid
    remove_column :whiteboards, :study_session_id
  end
end

class Whiteboard < ActiveRecord::Base
  set_table_name :whiteboards

  OPTIONAL_COMPONENTS = %w{chat invite profile voice etherpad documents images bottomtray email widgets math}
end

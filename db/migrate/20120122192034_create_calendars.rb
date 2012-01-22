class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :gmail_address
      t.string :gmail_password
      t.integer :schedule_id

      t.timestamps
    end
  end
end

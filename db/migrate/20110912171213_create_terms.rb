class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :school_id

      t.timestamps
    end
  end
end

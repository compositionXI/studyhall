class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :company_name
      t.string :phone
      t.text :message

      t.timestamps
    end
  end
end

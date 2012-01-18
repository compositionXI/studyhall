class RenameCompanyNameToSchoolNameOnContacts < ActiveRecord::Migration
  def change 
    change_table :contacts do |t|
      t.rename :company_name, :school_name
    end
  end
end

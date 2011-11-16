class AddNamesAndCustomUrlWhereTheyAreEmpty < ActiveRecord::Migration
  def up
    User.reset_column_information
    User.all.each do |user|
      user.first_name = "John" if user.first_name.blank?
      user.last_name = "Doe" if user.last_name.blank?
      user.custom_url = "user#{user.id}" if user.custom_url.blank?
      user.save(perform_validation: false)
    end
  end
  
  def down
  end
end

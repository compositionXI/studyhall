class AddNamesAndCustomUrlWhereTheyAreEmpty < ActiveRecord::Migration
  def up
    User.reset_column_information
    User.all.each do |user|
      user.first_name = "John" if user.first_name.nil? || user.first_name.empty?
      user.last_name = "Doe" if user.last_name.nil? || user.last_name.empty?
      if user.custom_url.nil? || user.custom_url.empty?
        salt = User.where(:first_name => "John", :last_name => "Doe").count + 1
        user.custom_url = user.name+salt.to_s 
      end
      user.save!
    end
  end
  
  def down
  end
end
class CreateExtracurricularsUsersJoinTable < ActiveRecord::Migration
  def self.up
      create_table :extracurriculars_users, :id => false do |t|
        t.integer :extracurricular_id
        t.integer :user_id
      end
  end

  def self.down
    drop_table :extracurriculars_users
  end
end

class CreateRecommendationsTable < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.integer :school_id
      t.text :conn_cda
      t.text :rank_cda
      
      t.timestamps
    end
  end
end

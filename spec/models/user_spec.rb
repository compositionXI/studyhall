require 'spec_helper'

describe User do
  it "can be instantiated" do
    User.new.should be_an_instance_of(User)
  end
  
  context "#follow!" do
    before(:all) do
      @user1 = test_user
      @user2 = test_user
    end

    it "should create a following" do
      Following.destroy_all
      @user1.follow!(@user2)
      Following.count.should == 1
    end

    it "should not allow self-following" do
      following = @user1.follow!(@user1)
      following.errors.size.should == 1
    end

    after(:all) do
      @user1.destroy
      @user2.destroy
    end
  end

  context "#follows?" do
    before(:all) do
      @user1 = test_user
      @user2 = test_user
      @user1.follow!(@user2)
    end

    it "should state whether a user follows another user" do
      @user1.follows?(@user2).should == true
    end

    it "should state when a user does NOT follow another user" do
      @user2.follows?(@user1).should == false
    end

    after(:all) do
      @user1.destroy
      @user2.destroy
    end
  end
    
  context "#followers" do
    before(:all) do
      @user1 = test_user
      @user2 = test_user
      @user3 = test_user
      @user1.follow!(@user2)
      @user3.follow!(@user2)
    end

    it "should return an AR::Relation of the user's followers" do
      @user2.followers.class.should == ActiveRecord::Relation
    end

    it "should return the correct number of users" do
      @user2.followers.count.should == 2
    end

    it "should include the correct users" do
      @user2.followers.all.include?(@user1).should == true
      @user2.followers.all.include?(@user3).should == true
    end

    after(:all) do
      @user1.destroy
      @user2.destroy
      @user3.destroy
    end
  end
    
end

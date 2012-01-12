require 'spec_helper'

describe User do
  let(:user) {FactoryGirl.create(:user)}
  
  it "can be instantiated" do
    User.new.should be_an_instance_of(User)
  end
  
  context "that has been created" do
    
    it "should have a school" do
      user.school.should_not nil
    end
    
    it "should not be able to change school" do
      school1 = FactoryGirl.create(:school)
      school2 = FactoryGirl.create(:school)
      user = FactoryGirl.create(:user, school: school1)
      orig_school = user.school
      user.update_attributes school: school2
      user.save
      user.school.should == orig_school
    end
  end
  
  context "gpa validation" do
    it "should be valid if gpa is nil" do
      user.gpa = nil
      user.should be_valid
    end

    [-1.0, 4.1, 4.01].each do |gpa_value|
      it "should not be valid if gpa is not between 0.0 and 4.0 ex: #{gpa_value}" do
        user.gpa = gpa_value 
        user.should_not be_valid
        user.should have(1).error_on(:gpa)
      end
    end

    [0.1, 2.3, 4.000].each do |gpa_value|
      it "should be valid if gpa is between 0.0 and 4.0 ex: #{gpa_value}" do
        user.gpa = gpa_value 
        user.should be_valid
      end
    end
  end

  context "#voted_for?" do
    before(:all) do
      @user1 = test_user
      @user2 = test_user
    end

    it "should return true if a user has voted FOR another" do
      @user1.vote_for(@user2)
      @user1.voted_for?(@user2).should == true
    end

    it "should return false if a user has not voted on another" do
      Vote.destroy_all
      @user1.voted_for?(@user2).should == false
    end

    it "should return false if a user has voted AGAINST another" do
      Vote.destroy_all
      @user1.vote_against(@user2)
      @user1.voted_for?(@user2).should == false
    end

    after(:all) do
      @user1.destroy
      @user2.destroy
    end
  end

  context "#block!" do 
    before(:all) do
      @user1 = test_user
      @user2 = test_user
    end

    it "should block another user" do
      Following.destroy_all
      @user1.follow!(@user2)
      Following.count.should == 1
      @user1.blocked?(@user2).should == false
      @user1.block!(@user2)
      @user1.blocked?(@user2).should == true
    end

    after(:all) do
      @user1.destroy
      @user2.destroy
    end
  end

  context "blocked?" do 
    before(:all) do
      @user1 = test_user
      @user2 = test_user
    end

     after(:all) do
      @user1.destroy
      @user2.destroy
    end


    it "should block another user" do
      Following.destroy_all
      @user1.follow!(@user2)
      Following.count.should == 1
      @user1.blocked?(@user2).should == false
      @user1.block!(@user2)
      @user1.blocked?(@user2).should == true
    end

    it "should not throw exceptions when asking about a nil user" do
      @user1.blocked?(nil).should == false
    end
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
  
  context "following" do 
    context "#following_for" do 
      it "should not fail when nil is passed" do 
        @user1 = test_user
        @user1.following_for(nil).should == nil
      end
    end
  end


  context "that has notebooks" do
      let(:user) {FactoryGirl.create(:user)}
      let(:course) {FactoryGirl.create(:course)}
      let(:notebook1) {FactoryGirl.create(:notebook, name: "Chem", course: course, user: user)}
      let(:notebook2) {FactoryGirl.create(:notebook, name: "Bio", course: course,  user: user)}
      let(:notebook3) {FactoryGirl.create(:notebook, name: "Accounting", course: nil,  user: user)}
    
    it "should order notebooks alphabetically" do
      ordered_notebooks = [notebook2, notebook1, notebook3]
      user.alpha_ordered_notebooks.should == ordered_notebooks
    end
  end
end

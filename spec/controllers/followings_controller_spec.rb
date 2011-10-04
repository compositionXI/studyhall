require 'spec_helper'

describe FollowingsController do

  describe "POST create" do
    before(:all) do
      @user1 = test_user
      @user2 = test_user
    end

    before(:each) do
      controller.stub!(:current_user).and_return(@user1)
    end
    before(:all) do
      @user1 = test_user
      @user2 = test_user
    end

    before(:each) do
      controller.stub!(:current_user).and_return(@user1)
    end

    it "should create a following between two users" do
      Following.destroy_all
      post :create, :following => {:followed_user_id => @user2.id}, :format => :js
      Following.count.should == 1
    end

    it "should return 200 when given valid parameters" do
      Following.destroy_all
      post :create, :following => {:followed_user_id => @user2.id}, :format => :js
      response.status.should == 200
    end

    after(:all) do
      @user1.destroy
      @user2.destroy
    end
  end

  describe "DELETE destroy" do
    before(:all) do
      @user1 = test_user
      @user2 = test_user
      Following.destroy_all
      @user1.follow!(@user2)
    end

    before(:each) do
      controller.stub!(:current_user).and_return(@user1)
    end

    it "should destroy any following between two users" do
      delete :destroy, :id => @user2.id, :format => :js
      Following.count.should == 0
    end
  end

end

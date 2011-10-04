require 'spec_helper'

describe Following do

  before(:all) do
    @user_herp = test_user
    @user_derp = test_user
  end

  it "will be empty" do
    @user_herp.followings.should == []
  end

  it "will let one user stalk another" do
    Following.create(:user => @user_herp, :followed_user => @user_derp)
    @user_derp.followers.map(&:id).should == [@user_herp.id]
  end

  after(:all) do
    @user_herp.destroy
    @user_derp.destroy
  end

end

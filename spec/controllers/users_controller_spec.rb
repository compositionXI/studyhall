require 'spec_helper'

describe UsersController do
  before(:all) do

  end

  before(:each) do
    @mock_user = mock_model(User, :name => "fake", :major => "fake", :gender => "male", :school_id => 1, :gpa => "2", :fraternity => "Omega Moo", :extracurriculars => "Booyah")
    @mock_user.stub!(:googleable?).and_return(true)
    controller.stub!(:current_user).and_return(test_user)
  end

  describe "GET 'show'" do
    it "should be able to fetch a url with underscores in it" do
      User.should_receive(:find_by_custom_url).with('custom_url').and_return(@mock_user)
      get 'show', :id => 'custom_url'
      response.should be_success
    end
  end

end

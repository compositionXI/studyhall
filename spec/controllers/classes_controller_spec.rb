require 'spec_helper'

describe ClassesController do
  describe "GET 'show'" do
    before :each do
      @offering = FactoryGirl.create(:offering)
      controller.stub!(:current_user).and_return(FactoryGirl.create(:user))
    end
    it "should be successful" do
      get :show, :id => @offering.id
      response.should be_success
    end
    it "should render the show template" do
      get :show, :id => @offering.id
      response.should render_template :show
    end
    it "should assign @class" do
      get :show, :id => @offering.id
      assigns[:class].should == @offering
    end
    it "should assign @course" do
      get :show, :id => @offering.id
      assigns[:course].should == @offering.course
    end
    it "should assign @classmates" do
      get :show, :id => @offering.id
      assigns[:classmates].should_not be_nil
    end
    it "should assign @posts" do
      get :show, :id => @offering.id
      assigns[:posts].should_not be_nil
    end
    it "should assign @shared_study_sessions" do
      get :show, :id => @offering.id
      assigns[:shared_study_sessions].should_not be_nil
    end
    it "should assign @shared_notes" do
      get :show, :id => @offering.id
      assigns[:shared_notes].should_not be_nil
    end
    it "should set the action_bar_message flash" do
      get :show, :id => @offering.id
      flash[:action_bar_message].should == @offering.course.title
    end
  end
end

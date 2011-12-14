require 'spec_helper'

describe ActivationsController do
  describe "GET 'show'" do
    it "should be successfully" do
      get :new
      response.should be_success
    end
    it "should render the new template" do
      get :new
      response.should render_template(:new)
    end
  end
  describe "POST 'create'" do
    before :each do
      @user = FactoryGirl.create(:user)
      User.stub!(:find_by_email).with(@user.email).and_return(@user)
      @user.stub!(:deliver_activation_instructions!)
    end
    it "should find out the user by email" do
      post :create, :email => @user.email
      assigns[:user].should == @user
    end
    context "when the user with the email is found" do
      context "and when the user is active" do
        before :each do
          @user.active = true
        end
        it "should set the error flash" do
          post :create, :email => @user.email
          flash[:error].should == "The account with this email is already activated."
        end
        it "should render the new template" do
          post :create, :email => @user.email
          response.should render_template :new
        end
      end
      context "and when the user is not active" do
        before :each do
          @user.active = false
        end
        it "should send the activation email" do
          @user.should_receive(:deliver_activation_instructions!)
          post :create, :email => @user.email
        end
        it "should set the error flash" do
          post :create, :email => @user.email
          flash[:notice].should == "Instructions to activate your account have been emailed to you. \nPlease check your email."
        end
        it "should redirect to the root url" do
          post :create, :email => @user.email
          response.should redirect_to root_url
        end
      end
    end

    context "when the user with the email is not found" do
      before :each do
        User.stub!(:find_by_email).with('non-existed@email.com').and_return(nil)
      end
      it "should set the error flash" do
        post :create, :email => 'non-existed@email.com'
        flash[:error].should == "No user was found with that email address."
      end
      it "should render the new template" do
        post :create, :email => 'non-existed@email.com'
        response.should render_template :new
      end
    end
  end
end

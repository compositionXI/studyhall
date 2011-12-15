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

  describe "POST 'create'" do
    before :each do
      @user_attributes = FactoryGirl.attributes_for(:user).stringify_keys
      @user = User.new @user_attributes
      User.stub!(:new).with(@user_attributes).and_return(@user)
      controller.stub!(:require_no_user_or_admin).and_return(true)
      @user.stub!("deliver_activation_instructions!")
    end
    it "should save without session maintenance" do
      @user.stub!(:save_without_session_maintenance).and_return(true)
      @user.should_receive(:save_without_session_maintenance).and_return(true)
      post_user @user_attributes
    end
    context "when it saves successfully" do
      before :each do
        @user.stub!(:save_without_session_maintenance).and_return(true)
        @user.stub!('new_record?').and_return(false)
        @user.stub!(:deliver_activation_instructions!)
      end
      it "should send the activation email" do
        @user.should_receive(:deliver_activation_instructions!)
        post_user @user_attributes
      end
      it "should set the notice message" do
        post_user @user_attributes
        flash[:notice].should == "Instructions to activate your account have been emailed to you. \nPlease check your email."
      end
      it "should redirect to login url" do
        post_user @user_attributes
        response.should redirect_to login_url
      end
    end
    context "when it fails to save" do
      before :each do
        @user.stub!(:save_without_session_maintenance).and_return(false)
        @user.stub!('new_record?').and_return(true)
      end
      it "should render the new template" do
        post_user @user_attributes
        response.should render_template :new
      end
      context "and when the email has been taken" do
        before :each do
          @user_with_same_email = User.new(@user_attributes)
          @user.errors.add(:email, 'has already been taken')
          User.stub!(:find_by_email).with(@user.email).and_return(@user_with_same_email)
        end
        it "should find out the user with the same email" do
          post_user @user_attributes
          assigns[:user_with_same_email].should == @user_with_same_email
        end
        context "and when the user is active" do
          before :each do
            @user_with_same_email.active = true
          end
          it "should set the error flash" do
            post_user @user_attributes
            flash[:error].should == "There is already an account with that email address. You can <a href='/password_resets/new'>reset your password</a> if you forget it.".html_safe
         end
        end
        context "and when the user is not active" do
          before :each do
            @user_with_same_email.active = false
          end
          it "should set the error flash" do
            post_user @user_attributes
            flash[:error] == "There is already an account with that email address. If you did not receive the activation message, we can <a href='/activations/new?email=#{@user_with_same_email.email}'>send it to you again.</a>".html_safe
          end
        end
      end
    end
  end

  private
  def post_user(attributes = {})
    post :create, :user => attributes
  end
end

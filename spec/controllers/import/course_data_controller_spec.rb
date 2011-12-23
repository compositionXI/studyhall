require 'spec_helper'

describe Import::CourseDataController do
  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    it "should render the new template" do
      get :new
      response.should render_template :new
    end
    it "should assign @course_offering_import" do
      get :new
      assigns[:course_offering_import].should be_a(CourseOfferingImport)
    end
  end
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
    it "should render the index template" do
      get :index
      response.should render_template :index
    end
    it "should assign @course_offering_imports" do
      course_offering_import = FactoryGirl.create(:course_offering_import)
      get :index
      assigns[:course_offering_imports].should eq([course_offering_import])
    end
  end
  describe "GET 'edit'" do
    before :each do
      @course_offering_import = FactoryGirl.create(:course_offering_import)
    end
    it "should be successful" do
      get :edit, :id => @course_offering_import.id
      response.should be_success
    end
    it "should render the edit template" do
      get :edit, :id => @course_offering_import.id
      response.should render_template :edit
    end
    it "should assign @course_offering_imports" do
      get :edit, :id => @course_offering_import.id
      assigns[:course_offering_import].should == @course_offering_import
    end
  end
  describe "GET 'create'" do
    context "with valid attributes" do
      before :each do
        @course_offering_import_attributes = FactoryGirl.attributes_for(:course_offering_import)
      end
      it "should be redirected" do
        post :create, :course_offering_import => @course_offering_import_attributes
        response.should redirect_to import_course_data_path
      end
      it "should assign @course_offering_import" do
        post :create, :course_offering_import => @course_offering_import_attributes
        assigns[:course_offering_import].should be_a(CourseOfferingImport)
       end
      it "should create the resource" do
        post :create, :course_offering_import => @course_offering_import_attributes
        CourseOfferingImport.count.should == 1
      end
    end
  end
  describe "DELETE 'destory'" do
    before :each do
      @course_offering_import = FactoryGirl.create(:course_offering_import)
    end
    context "when the resource is found" do
      it "should assign @course_offering_import" do
        post :destroy, :id => @course_offering_import.id
        assigns[:course_offering_import].should == @course_offering_import 
      end
      it "should be redirected" do
        post :destroy, :id => @course_offering_import.id
        response.should redirect_to import_course_data_path
      end
      it "should delete the resource" do
        post :destroy, :id => @course_offering_import.id
        CourseOfferingImport.count.should == 0
      end
    end
    context "when the resource is not found" do
      it "should not delete the resource" do
        post :destory, :id => @course_offering_import.id + 1
        CourseOfferingImport.count.should == 1
      end
    end
  end
end

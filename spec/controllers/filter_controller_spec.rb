require 'spec_helper'

describe FiltersController do
  describe "GET 'new'" do
    
    def get_new
      xhr :get, :new, model_name: "Note"
    end
    
    it "should be successful" do
      get_new
      response.should be_success
    end
    
    it "should assign @filter_form" do
      get_new
      assigns[:filter_form].should eq("notes_form")
    end
    
    it "should assign @filter" do
      get_new
      @filter = Filter.new(:model_name => "Note")
      assigns[:filter].should_not be_nil
    end
  end
  
  describe "POST 'create'" do
    
    def post_create
      xhr :post, :create, filter: {model_name: "Note", notes: "1", note: {name: "Test Note"}}
    end
    
    it "should be successful" do
      post_create
      response.should be_redirect
    end
    
    it "should assign @filter" do
      post_create
      @Filter = Filter.new(model_name: "Note")
      assigns[:filter].should_not be_nil
    end
  end
end
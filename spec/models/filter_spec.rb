require 'spec_helper'

describe Filter do
  
  let(:filter) {Filter.new(:model_name => "Notebook")}
  
  it "should set a model_name and object of that type when initialized" do
    filter.model_name.should == "Notebook"
    filter.object.is_a?(Notebook).should == true
  end
  
  it "should return a hash of attributes" do
    filter.attributes.should_not be_nil
  end
  
  it "should requrn a query string" do
    filter.query_params.is_a?(String).should == true
  end
  
  it "should determine if a model has a given attribute" do
    filter.attribute_of?(:name, Note).should == true
  end
end

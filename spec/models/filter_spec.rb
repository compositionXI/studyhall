require 'spec_helper'

describe Filter do
  
  before :all do
  end
  
  it "should set a model_name when initialized" do
    @filter = Filter.new(:model_name => "Notebook")
    @filter.model_name.should == "Notebook"
  end
end

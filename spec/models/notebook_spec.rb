require "spec_helper"

describe Notebook do

  let(:user) {FactoryGirl.create(:user)}
  let(:course) {FactoryGirl.create(:course)}
  let(:notebook1) {FactoryGirl.create(:notebook, name: "Chem", course: course, user: user)}
  let(:notebook2) {FactoryGirl.create(:notebook, name: "Bio", course: course,  user: user)}
  let(:notebook3) {FactoryGirl.create(:notebook, name: "Accounting", course: nil,  user: user)}
  
  it "can be instantiated" do
    Notebook.new.should be_an_instance_of(Notebook)
  end

  it "should order notebooks alphabetically" do
    ordered_notebooks = [notebook2, notebook1, notebook3]
    Notebook.alpha_ordered(user.notebooks).should == ordered_notebooks
  end
  
  it "should find notebooks within a date range" do
    notebook = FactoryGirl.create(:notebook, created_at: 2.weeks.ago, user: user )
    Notebook.in_range(3.weeks.ago, 1.week.ago).should == [notebook]
  end
end
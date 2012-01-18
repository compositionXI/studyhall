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
    Notebook.in_range(3.weeks.ago.to_s, 1.week.ago.to_s).should == [notebook]
  end
  
  context "when filtered" do
    it "should find notebooks for a given user" do
      Notebook.filter_for(user, {notebooks: "1", notebook: {name: notebook2.name}}).include?(notebook2).should == true
    end
    
    it "should find notebooks by partial name match" do
      notebook1
      Notebook.filter_for(user, {notebooks: "1", notebook: {name: "che"}}).include?(notebook1).should == true
    end
    
    it "should find notebooks by course_id" do
      notebook4 = FactoryGirl.create(:notebook, name: "Test Notebook", course: course, user: user)
      Notebook.filter_for(user, {notebooks: "1", notebook: {course_id: course.id}}).include?(notebook4).should == true
    end
    
    it "should find notebooks by date range that specifies both the start_date and end_date" do
      notebook4 = FactoryGirl.create(:notebook, created_at: 1.week.ago, user: user)
      Notebook.filter_for(user, {notebooks: "1", start_date: 2.weeks.ago.to_s, end_date: 1.day.ago.to_s}).include?(notebook4).should == true
    end
    
    it "should find notebooks by date range that specifies only a start_date" do
      notebook4 = FactoryGirl.create(:notebook, created_at: 1.week.ago, user: user)
      Notebook.filter_for(user, {notebooks: "1", start_date: 2.weeks.ago.to_s}).include?(notebook4).should == true
    end
    
    it "should find notebooks by date range that specifies an end_date that matches the date a notebook was created" do
      end_date = 1.day.ago
      notebook4 = FactoryGirl.create(:notebook, created_at: end_date, user: user)
      Notebook.filter_for(user, {notebooks: "1", end_date: end_date.to_s}).include?(notebook4).should == true
    end
  end
end
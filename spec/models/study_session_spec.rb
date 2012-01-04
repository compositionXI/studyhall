require "spec_helper"

describe StudySession do
  let(:user) {FactoryGirl.create(:user)}
  let(:school) {FactoryGirl.create(:school)}
  let(:course) {FactoryGirl.create(:course, school: school)}
  let(:offering) {FactoryGirl.create(:offering, school: school, course: course)}
  let(:study_session) {FactoryGirl.create(:study_session, user: user, offering: offering)}
  
  it "can be instantiated" do
    StudySession.new.should be_an_instance_of(StudySession)
  end
  
  it "should find study_session within a date range" do
    note = FactoryGirl.create(:study_session, created_at: 2.week.ago, user: user )
    StudySession.in_range(3.weeks.ago.to_s, 1.week.ago.to_s).should == [note]
  end
  
  it "should filter study_sessions for a user" do
    users = Array.new(2){FactoryGirl.create(:user)}
    user_ids = users.collect{|u| u.id}
    studyhalls = Array.new(2) {FactoryGirl.create(:study_session, user: user, users: users, offering: offering, name: "test")}
    StudySession.filter( {study_session: {offering_id: offering.id, name: "tes"}, user_ids: user_ids}, user).should == studyhalls
  end
  
  it "should find all of the offerings for all of the study_sessions for a given user" do
    offering = FactoryGirl.create(:offering, school: school, course: course)
    study_session = FactoryGirl.create(:study_session, user: user, offering: offering)
    StudySession.offerings_for(user).should == [offering]
  end
end
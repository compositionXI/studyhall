require "spec_helper"

describe Note do
  
  let(:user) {FactoryGirl.create(:user)}
  let(:note) {FactoryGirl.create(:note, user: user)}
  
  it "can be instantiated" do
    Note.new.should be_an_instance_of(Note)
  end
  
  it "should find note within a date range" do
    note = FactoryGirl.create(:note, created_at: 2.week.ago, user: user )
    Note.in_range(3.weeks.ago, 1.week.ago).should == [note]
  end
  
  describe "#check_note_name" do
    it "should assign default name to note if user didn't specify" do
      note = Factory(:note, name: '', user: user)
      note.name.should == "Quick Save - #{note.owner.notes.count - 1}"
    end
  end
end
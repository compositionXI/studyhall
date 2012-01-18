require "spec_helper"

describe Note do
  
  let(:user) {FactoryGirl.create(:user)}
  let(:note) {FactoryGirl.create(:note, user: user)}
  let(:notebook) {Factory.create(:notebook, user: user, shareable: true)}
  
  it "can be instantiated" do
    Note.new.should be_an_instance_of(Note)
  end
  
  it "should find note within a date range" do
    note = FactoryGirl.create(:note, created_at: 2.week.ago, user: user )
    Note.in_range(3.weeks.ago.to_s, 1.week.ago.to_s).should == [note]
  end
  
  context "when filtered" do
    it "should find notes for a given user" do
      note2 = FactoryGirl.create(:note, name: "Test Note", user: user)
      Note.filter_for(user, {notes: "1", note: {name: note2.name}}).include?(note2).should == true
    end
    
    it "should find notes by partial name match" do
      note2 = FactoryGirl.create(:note, name: "Test Note", user: user)
      Note.filter_for(user, {notes: "1", note: {name: "tes"}}).include?(note2).should == true
    end
    
    it "should find notes by date range that specifies both the start_date and end_date" do
      note2 = FactoryGirl.create(:note, created_at: 1.week.ago, user: user)
      Note.filter_for(user, {notes: "1", start_date: 2.weeks.ago.to_s, end_date: 1.day.ago.to_s}).include?(note2).should == true
    end
    
    it "should find notes by date range that specifies only a start_date" do
      note2 = FactoryGirl.create(:note, created_at: 1.week.ago, user: user)
      Note.filter_for(user, {notes: "1", start_date: 2.weeks.ago.to_s}).include?(note2).should == true
    end
    
    it "should find notes by date range that specifies an end_date that matches the date a note was created" do
      end_date = 1.day.ago
      note2 = FactoryGirl.create(:note, created_at: end_date, user: user)
      Note.filter_for(user, {notes: "1", end_date: end_date.to_s}).include?(note2).should == true
    end
  end
  
  describe "#check_note_name" do
    it "should assign default name to note if user didn't specify" do
      note = Factory(:note, name: '', user: user)
      note.name.should == "Quick Save - #{note.owner.notes.count - 1}"
    end
  end
  
  describe "#take_parent_permission" do
    it "should take parent notebook's permission if note is move into the notebook" do
      note.notebook = notebook
      note.save
      note.shareable.should == true
      note.notebook_changed.should == true
    end
  end
end
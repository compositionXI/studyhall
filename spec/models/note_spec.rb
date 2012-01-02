require "spec_helper"

describe Note do
  
  let(:user) {FactoryGirl.create(:user)}
  let(:note) {FactoryGirl.create(:note, user: user)}
  
  it "can be instantiated" do
    Note.new.should be_an_instance_of(Note)
  end
  
  it "should find note within a date range" do
    note = FactoryGirl.create(:note, created_at: 2.week.ago, user: user )
    Note.in_range(3.weeks.ago.to_s, 1.week.ago.to_s).should == [note]
  end
  
  describe "#check_note_name" do
    it "should assign default name to note if user didn't specify" do
      note = Factory(:note, name: '', user: user)
      note.name.should == "Quick Save - #{note.owner.notes.count - 1}"
    end
  end
  
  describe "#take_parent_permission" do
    it "should take parent notebook's permission if note is move into the notebook" do
      note = Factory(:note, user: user, shareable: false)
      notebook = Factory(:notebook, user: user, shareable: true)
      note.notebook = notebook
      note.save
      note.shareable.should == true
      note.notebook_changed.should == true
    end
  end
end
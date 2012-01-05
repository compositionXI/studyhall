require "spec_helper"

describe Backpack do
  
  let(:user) {Factory.create(:user)}
  
  it "can be instatiated" do
    Backpack.new(user).should be_an_instance_of(Backpack)
  end
  
  describe "contents" do
    let(:user) {Factory.create(:user)}
    let(:note) {Factory.create(:note, user: user)}
    let(:notebook) {Factory.create(:notebook, user: user)}
    
    before :each do
      @user = Factory.create(:user)
      @note = Factory.create(:note, user: @user)
      @notebook = Factory.create(:notebook, user: @user)
    end
    
    it "should get the contents" do
      @backpack = Backpack.new(user)
      @backpack.contents.is_a?(Array).should == true
    end
    
    it "should get a users note and notebooks" do
      @backpack = Backpack.new(@user)
      @backpack.contents.include?(@user.notes.first).should == true
      @backpack.contents.include?(@user.notebooks.first).should == true
    end
    
    context "with filter" do
      it "should return only the notes for that filter" do
        @note2 = Factory.create(:note, user: @user, name: "Test Note")
        @backpack = Backpack.new(@user)
        @backpack.contents(filter: {notes: "1", note: {name: @note2.name}}).include?(@note2).should == true
      end
    end
  end
  
end
require 'spec_helper'

describe "calendars/edit" do
  before(:each) do
    @calendar = assign(:calendar, stub_model(Calendar,
      :gmail_address => "MyString",
      :gmail_password => "MyString",
      :schedule_id => 1
    ))
  end

  it "renders the edit calendar form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => calendars_path(@calendar), :method => "post" do
      assert_select "input#calendar_gmail_address", :name => "calendar[gmail_address]"
      assert_select "input#calendar_gmail_password", :name => "calendar[gmail_password]"
      assert_select "input#calendar_schedule_id", :name => "calendar[schedule_id]"
    end
  end
end

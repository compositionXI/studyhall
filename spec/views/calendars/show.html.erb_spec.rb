require 'spec_helper'

describe "calendars/show" do
  before(:each) do
    @calendar = assign(:calendar, stub_model(Calendar,
      :gmail_address => "Gmail Address",
      :gmail_password => "Gmail Password",
      :schedule_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Gmail Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Gmail Password/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end

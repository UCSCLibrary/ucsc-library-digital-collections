require 'rails_helper'

RSpec.describe "bmi_edits/index", type: :view do
  before(:each) do
    assign(:bmi_edits, [
      BmiEdit.create!(
        :work_ids => "MyText",
        :status => "Status",
        :user => "User",
        :comment => "MyText",
        :workflow_id => 2,
        :workflow_action_id => 3
      ),
      BmiEdit.create!(
        :work_ids => "MyText",
        :status => "Status",
        :user => "User",
        :comment => "MyText",
        :workflow_id => 2,
        :workflow_action_id => 3
      )
    ])
  end

  it "renders a list of bmi_edits" do
    render
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end

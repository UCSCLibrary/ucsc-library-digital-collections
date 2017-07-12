require 'rails_helper'

RSpec.describe "bmi_edits/show", type: :view do
  before(:each) do
    @bmi_edit = assign(:bmi_edit, BmiEdit.create!(
      :work_ids => "MyText",
      :status => "Status",
      :user => "User",
      :comment => "MyText",
      :workflow_id => 2,
      :workflow_action_id => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/User/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end

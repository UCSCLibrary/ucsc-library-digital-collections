require 'rails_helper'

RSpec.describe "bmi_edits/new", type: :view do
  before(:each) do
    assign(:bmi_edit, BmiEdit.new(
      :work_ids => "MyText",
      :status => "MyString",
      :user => "MyString",
      :comment => "MyText",
      :workflow_id => 1,
      :workflow_action_id => 1
    ))
  end

  it "renders new bmi_edit form" do
    render

    assert_select "form[action=?][method=?]", bmi_edits_path, "post" do

      assert_select "textarea#bmi_edit_work_ids[name=?]", "bmi_edit[work_ids]"

      assert_select "input#bmi_edit_status[name=?]", "bmi_edit[status]"

      assert_select "input#bmi_edit_user[name=?]", "bmi_edit[user]"

      assert_select "textarea#bmi_edit_comment[name=?]", "bmi_edit[comment]"

      assert_select "input#bmi_edit_workflow_id[name=?]", "bmi_edit[workflow_id]"

      assert_select "input#bmi_edit_workflow_action_id[name=?]", "bmi_edit[workflow_action_id]"
    end
  end
end

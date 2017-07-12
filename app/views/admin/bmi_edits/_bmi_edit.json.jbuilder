json.extract! bmi_edit, :id, :work_ids, :status, :user, :deadline, :comment, :workflow_id, :workflow_action_id, :created_at, :updated_at
json.url bmi_edit_url(bmi_edit, format: :json)

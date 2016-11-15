json.array!(@bmi_ingests) do |bmi_ingest|
  json.extract! bmi_ingest, :id, :user_id, :filename, :status, :class, :identifier, :replace_files
  json.url bmi_ingest_url(bmi_ingest, format: :json)
end

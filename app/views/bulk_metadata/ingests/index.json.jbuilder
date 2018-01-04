json.array!(@ingests) do |ingest|
  json.extract! ingest, :id, :user_id, :filename, :status, :class, :identifier, :replace_files
  json.url ingest_url(ingest, format: :json)
end

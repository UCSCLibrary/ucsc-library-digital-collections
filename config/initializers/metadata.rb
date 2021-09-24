# require 'scooby_snacks/initialize'
# Constant required by other initializers that load before this one
Rails.application.config.before_initialize do
  ScoobySnacks::METADATA_SCHEMA = Ucsc::MetadataSchema.new
end

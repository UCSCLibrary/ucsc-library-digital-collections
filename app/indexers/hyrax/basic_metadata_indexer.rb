# frozen_string_literal: true

require_dependency Hyrax::Engine.root.join('app', 'indexers', 'hyrax', 'basic_metadata_indexer').to_s

# TODO: delete this file once Scooby Snacks is removed -- the overrides will no longer be needed
Hyrax::BasicMetadataIndexer.class_eval do
  # OVERRIDE: convert rights_statement and date_created to camel case to work with ScoobySnacks
  self.stored_fields = %i[description license rightsStatement dateCreated identifier related_url bibliographic_citation source]
end

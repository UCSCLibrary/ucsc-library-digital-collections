# OVERRIDE FILE from Bulkrax v1.0.2
require_dependency Bulkrax::Engine.root.join('app', 'models', 'concerns', 'bulkrax', 'import_behavior').to_s

Bulkrax::ImportBehavior.class_eval do
  # OVERRIDE: change rights_statement to rightsStatement
  def add_rights_statement
    self.parsed_metadata['rightsStatement'] = [parser.parser_fields['rights_statement']] if override_rights_statement || self.parsed_metadata['rightsStatement'].blank?
  end
end

# frozen_string_literal: true

require_dependency Bulkrax::Engine.root.join('app', 'parsers', 'bulkrax', 'application_parser').to_s

# OVERRIDE FILE from Bulkrax v2.0.2
Bulkrax::ApplicationParser.class_eval do
  def write_import_file(file)
    path = File.join(path_for_import, file.original_filename)
    FileUtils.mv(
      file.path,
      path
    )
    FileUtils.chmod(0644, path) # OVERRIDE: chmod imported file to have read permissions
    path
  end
end

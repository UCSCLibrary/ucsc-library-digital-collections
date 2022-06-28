# frozen_string_literal: true

Bulkrax.setup do |config|
  # Add local parsers
  # config.parsers += [
  #   { name: 'MODS - My Local MODS parser', class_name: 'Bulkrax::ModsXmlParser', partial: 'mods_fields' },
  # ]
  config.parsers = [{ name: 'CSV - Comma Separated Values', class_name: 'Bulkrax::CsvParser', partial: 'csv_fields' }]

  # WorkType to use as the default if none is specified in the import
  # Default is the first returned by Hyrax.config.curation_concerns
  config.default_work_type = 'Work'

  # Path to store pending imports
  # config.import_path = 'tmp/imports'

  # Path to store exports before download
  # config.export_path = 'tmp/exports'

  # Server name for oai request header
  # config.server_name = 'my_server@name.com'

  # NOTE: Creating Collections using the collection_field_mapping will no longer supported as of version Bulkrax v2.
  #       Please configure Bulkrax to use related_parents_field_mapping and related_children_field_mapping instead.
  # Field_mapping for establishing a collection relationship (FROM work TO collection)
  # This value IS NOT used for OAI, so setting the OAI parser here will have no effect
  # The mapping is supplied per Entry, provide the full class name as a string, eg. 'Bulkrax::CsvEntry'
  # The default value for CSV is collection
  # Add/replace parsers, for example:
  # config.collection_field_mapping['Bulkrax::RdfEntry'] = 'http://opaquenamespace.org/ns/set'

  # Field mappings
  # Create a completely new set of mappings by replacing the whole set as follows
  #   config.field_mappings = {
  #     "Bulkrax::OaiDcParser" => { **individual field mappings go here*** }
  #   }

  config.field_mappings = {
    'Bulkrax::CsvParser' => {
      'bulkrax_identifier' => { from: ['bulkrax_identifier'], source_identifier: true },
      'file' => { from: %w[filename file], split: /\s*[|]\s*/, join: true },
      'model' => { from: %w[work_type worktype type model] },
      'title' => { from: %w[title], split: /\s*[|]\s*/, join: true },
      'visibility' => { from: %w[visibility] },
      'parent' => { from: %w[parent], split: /\s*[|]\s*/, join: true, related_parents_field_mapping: true },
      'titleAlternative' => { from: %w[title_alternative titlealternative], split: /\s*[|]\s*/, join: true },
      'accessRights' => { from: %w[access_rights accessrights], split: /\s*[|]\s*/, join: true },
      'accessionNumber' => { from: %w[accession_number accessionnumber], split: /\s*[|]\s*/, join: true },
      'boxFolder' => { from: %w[box_folder boxfolder], split: /\s*[|]\s*/, join: true },
      'collectionCallNumber' => { from: %w[collection_call_number collectioncallnumber], split: /\s*[|]\s*/, join: true },
      'contributor' => { from: %w[contributor], split: /\s*[|]\s*/, join: true },
      'coordinates' => { from: %w[coordinates], split: /\s*[|]\s*/, join: true },
      'creator' => { from: %w[creator], split: /\s*[|]\s*/, join: true },
      'dateCreated' => { from: %w[date_created datecreated], split: /\s*[|]\s*/, join: true },
      'dateCreatedDisplay' => { from: %w[date_created_display datecreateddisplay], split: /\s*[|]\s*/, join: true },
      'dateCreatedIngest' => { from: %w[date_created_ingest datecreatedingest], split: /\s*[|]\s*/, join: true },
      'dateDigitized' => { from: %w[date_digitized datedigitized], split: /\s*[|]\s*/, join: true },
      'dateOfSituation' => { from: %w[date_of_situation dateofsituation], split: /\s*[|]\s*/, join: true },
      'dateOfSituationDisplay' => { from: %w[date_of_situation_display dateofsituationdisplay], split: /\s*[|]\s*/, join: true },
      'dateOfSituationIngest' => { from: %w[date_of_situation_ingest dateofsituationingest], split: /\s*[|]\s*/, join: true },
      'datePublished' => { from: %w[date_published datepublished], split: /\s*[|]\s*/, join: true },
      'description' => { from: %w[description], split: /\s*[|]\s*/, join: true },
      'descriptionAddress' => { from: %w[description_address descriptionaddress], split: /\s*[|]\s*/, join: true },
      'descriptionNeighborhood' => { from: %w[description_neighborhood descriptionneighborhood], split: /\s*[|]\s*/, join: true },
      'descriptionStreet' => { from: %w[description_street descriptionstreet], split: /\s*[|]\s*/, join: true },
      'displayRole' => { from: %w[display_role displayrole], split: /\s*[|]\s*/, join: true },
      'donorProvenance' => { from: %w[donor_provenance donorprovenance], split: /\s*[|]\s*/, join: true },
      'extent' => { from: %w[extent], split: /\s*[|]\s*/, join: true },
      'genre' => { from: %w[genre], split: /\s*[|]\s*/, join: true },
      'harmfulLanguageStatement' => { from: %w[harmful_language_statement harmfullanguagestatement], split: /\s*[|]\s*/, join: true },
      'independentlyDisplayed' => { from: %w[independently_displayed independentlydisplayed], split: /\s*[|]\s*/, join: true },
      'itemCallNumber' => { from: %w[item_call_number itemcallnumber], split: /\s*[|]\s*/, join: true },
      'language' => { from: %w[language], split: /\s*[|]\s*/, join: true },
      'primaryFilename' => { from: %w[primary_filename primaryfilename], split: /\s*[|]\s*/, join: true },
      'metadataInheritance' => { from: %w[metadata_inheritance metadatainheritance], split: /\s*[|]\s*/, join: true },
      'metadataSource' => { from: %w[metadata_source metadatasource], split: /\s*[|]\s*/, join: true },
      'originalPublisher' => { from: %w[original_publisher originalpublisher], split: /\s*[|]\s*/, join: true },
      'physicalDescription' => { from: %w[physical_description physicaldescription], split: /\s*[|]\s*/, join: true },
      'physicalFormat' => { from: %w[physical_format physicalformat], split: /\s*[|]\s*/, join: true },
      'publisher' => { from: %w[publisher], split: /\s*[|]\s*/, join: true },
      'publisherHomepage' => { from: %w[publisher_homepage publisherhomepage], split: /\s*[|]\s*/, join: true },
      'relatedResource' => { from: %w[related_resource relatedresource], split: /\s*[|]\s*/, join: true },
      'resourceType' => { from: %w[resource_type resourcetype], split: /\s*[|]\s*/, join: true },
      'rightsHolder' => { from: %w[rights_holder rightsholder], split: /\s*[|]\s*/, join: true },
      'rightsStatement' => { from: %w[rights_statement rightsstatement], split: /\s*[|]\s*/, join: true },
      'rightsStatus' => { from: %w[rights_status rightsstatus], split: /\s*[|]\s*/, join: true },
      'scale' => { from: %w[scale], split: /\s*[|]\s*/, join: true },
      'series' => { from: %w[series], split: /\s*[|]\s*/, join: true },
      'source' => { from: %w[source], split: /\s*[|]\s*/, join: true },
      'staffNote' => { from: %w[staff_note staffnote], split: /\s*[|]\s*/, join: true },
      'subjectName' => { from: %w[subject_name subjectname], split: /\s*[|]\s*/, join: true },
      'subjectPlace' => { from: %w[subject_place subjectplace], split: /\s*[|]\s*/, join: true },
      'subjectTitle' => { from: %w[subject_title subjecttitle], split: /\s*[|]\s*/, join: true },
      'subjectTopic' => { from: %w[subject_topic subjecttopic], split: /\s*[|]\s*/, join: true }
    }
  }

  # Add to, or change existing mappings as follows
  #   e.g. to exclude date
  #   config.field_mappings["Bulkrax::OaiDcParser"]["date"] = { from: ["date"], excluded: true  }
  #
  # #   e.g. to add the required source_identifier field
  #   #   config.field_mappings["Bulkrax::CsvParser"]["source_id"] = { from: ["old_source_id"], source_identifier: true  }
  # If you want Bulkrax to fill in source_identifiers for you, see below

  # To duplicate a set of mappings from one parser to another
  #   config.field_mappings["Bulkrax::OaiOmekaParser"] = {}
  #   config.field_mappings["Bulkrax::OaiDcParser"].each {|key,value| config.field_mappings["Bulkrax::OaiOmekaParser"][key] = value }

  # Should Bulkrax make up source identifiers for you? This allow round tripping
  # and download errored entries to still work, but does mean if you upload the
  # same source record in two different files you WILL get duplicates.
  # It is given two aruguments, self at the time of call and the index of the reocrd
  #    config.fill_in_blank_source_identifiers = ->(parser, index) { "b-#{parser.importer.id}-#{index}"}
  # or use a uuid
  #    config.fill_in_blank_source_identifiers = ->(parser, index) { SecureRandom.uuid }
  config.fill_in_blank_source_identifiers = ->(parser, index) { "#{parser.importerexporter.id}-#{index}" }

  # Properties that should not be used in imports/exports. They are reserved for use by Hyrax.
  # config.reserved_properties += ['my_field']

  # List of Questioning Authority properties that are controlled via YAML files in
  # the config/authorities/ directory. For example, the :rights_statement property
  # is controlled by the active terms in config/authorities/rights_statements.yml
  # Defaults: 'rights_statement' and 'license'
  # config.qa_controlled_properties += ::Ucsc::MetadataSchema.new.controlled_field_names
end

Rails.application.config.to_prepare do
  # Sidebar for hyrax 3+ support
  Hyrax::DashboardController.sidebar_partials[:repository_content] << "hyrax/dashboard/sidebar/bulkrax_sidebar_additions" if Object.const_defined?(:Hyrax) && ::Hyrax::DashboardController&.respond_to?(:sidebar_partials)
end

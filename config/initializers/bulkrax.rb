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

  # Field_mapping for establishing a parent-child relationship (FROM parent TO child)
  # This can be a Collection to Work, or Work to Work relationship
  # This value IS NOT used for OAI, so setting the OAI Entries here will have no effect
  # The mapping is supplied per Entry, provide the full class name as a string, eg. 'Bulkrax::CsvEntry'
  # Example:
  #   {
  #     'Bulkrax::RdfEntry'  => 'http://opaquenamespace.org/ns/contents',
  #     'Bulkrax::CsvEntry'  => 'children'
  #   }
  # By default no parent-child relationships are added
  # config.parent_child_field_mapping = { }

  # Field_mapping for establishing a collection relationship (FROM work TO collection)
  # This value IS NOT used for OAI, so setting the OAI parser here will have no effect
  # The mapping is supplied per Entry, provide the full class name as a string, eg. 'Bulkrax::CsvEntry'
  # The default value for CSV is collection
  # Add/replace parsers, for example:
  config.collection_field_mapping['Bulkrax::CsvEntry'] = 'parent'

  # Field mappings
  # Create a completely new set of mappings by replacing the whole set as follows
  #   config.field_mappings = {
  #     "Bulkrax::OaiDcParser" => { **individual field mappings go here*** }
  #   }

  config.field_mappings = {
    'Bulkrax::CsvParser' => {
      # Bulkrax mappings
      'bulkrax_identifier' => { from: ['bulkrax_identifier'], source_identifier: true },
      'file' => { from: ['filename'] },
      'model' => { from: ['worktype', 'type'] },
      # Metadata mappings
      'accessRights' => { from: ['accessrights'] },
      'accessionNumber' => { from: ['accessionnumber'] },
      'based_near' => { from: ['based_near', 'basednear'] }, # only defined on Course
      'bibliographic_citation' => { from: ['bibliographic_citation', 'bibliographiccitation'] }, # only defined on Course
      'boxFolder' => { from: ['boxfolder'] },
      'collectionCallNumber' => { from: ['collectioncallnumber'] },
      'contributor' => { from: ['contributor'] },
      'coordinates' => { from: ['coordinates'] },
      'creator' => { from: ['creator'] },
      # 'date_created' => { from: ['date_created'] }, # only defined on Course, use alt dateCreated
      'dateCreated' => { from: ['datecreated'] },
      'dateCreatedDisplay' => { from: ['datecreateddisplay'] },
      # 'date_digitized' => { from: ['date_digitized'] }, # only defined on Course and Lecture, use alt dateDigitized
      'dateDigitized' => { from: ['datedigitized'] },
      'dateOfSituation' => { from: ['dateofsituation'] },
      'datePublished' => { from: ['datepublished'] },
      'description' => { from: ['description'] },
      'descriptionAddress' => { from: ['descriptionaddress'] },
      'descriptionFeature' => { from: ['descriptionfeature'] },
      'descriptionNeighborhood' => { from: ['descriptionneighborhood'] },
      'descriptionStreet' => { from: ['descriptionstreet'] },
      'descriptionTownshipRange' => { from: ['descriptiontownshiprange'] },
      'digital_extent' => { from: ['digital_extent', 'digitalextent'] }, # only defined on Course and Lecture
      'digital_publisher_homepage' => { from: ['digital_publisher_homepage', 'digitalpublisherhomepage'] }, # only defined on Course and Lecture
      'displayRole' => { from: ['displayrole'] },
      'donorProvenance' => { from: ['donorprovenance'] },
      'extent' => { from: ['extent'] },
      'genre' => { from: ['genre'] },
      'identifier' => { from: ['identifier'] }, # only defined on Course
      'import_url' => { excluded: true },
      'independentlyDisplayed' => { from: ['independentlydisplayed'] },
      'itemCallNumber' => { from: ['itemcallnumber'] },
      'keyword' => { from: ['keyword'] },
      'label' => { from: ['label'] },
      'language' => { from: ['language'] },
      'license' => { from: ['license'] }, # only defined on Course
      'masterFilename' => { from: ['masterfilename'] },
      'metadataInheritance' => { from: ['metadatainheritance'] },
      'metadataSource' => { from: ['metadatasource'] },
      'originalPublisher' => { from: ['originalpublisher'] },
      'owner' => { excluded: true },
      'physicalDescription' => { from: ['physicaldescription'] },
      # 'physical_format' => { from: ['physical_format'] }, # only defined on Course and Lecture, use alt physicalFormat
      'physicalFormat' => { from: ['physicalformat'] },
      'publisher' => { from: ['publisher'] },
      'publisherHomepage' => { from: ['publisherhomepage'] },
      'relatedResource' => { from: ['relatedresource'] },
      'related_url' => { from: ['related_url', 'relatedurl'] }, # only defined on Course
      'relative_path' => { excluded: true },
      # 'resource_type' => { from: ['resource_type'] }, # only defined on Course and Lecture, use alt resourceType
      'resourceType' => { from: ['resourcetype'] },
      'rightsHolder' => { from: ['rightsholder'] },
      # 'rights_statement' => { from: ['rights_statement'] }, # only defined on Course, use alt rightsStatement
      'rightsStatement' => { from: ['rightsstatement'] },
      'rightsStatus' => { from: ['rightsstatus'] },
      'scale' => { from: ['scale'] },
      'series' => { from: ['series'] },
      'source' => { from: ['source'] },
      'staffNote' => { from: ['staffnote'] },
      'subject' => { from: ['subject'] }, # only defined on Course
      'subjectName' => { from: ['subjectname'] },
      'subjectPlace' => { from: ['subjectplace'] },
      'subjectTemporal' => { from: ['subjecttemporal'] },
      'subjectTitle' => { from: ['subjecttitle'] },
      'subjectTopic' => { from: ['subjecttopic'] },
      'subseries' => { from: ['subseries'] },
      'theme' => { from: ['theme'] },
      'title' => { from: ['title'] },
      'titleAlternative' => { from: ['titlealternative'] }
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
end

Rails.application.config.to_prepare do
  # Sidebar for hyrax 3+ support
  Hyrax::DashboardController.sidebar_partials[:repository_content] << "hyrax/dashboard/sidebar/bulkrax_sidebar_additions" if Object.const_defined?(:Hyrax) && ::Hyrax::DashboardController&.respond_to?(:sidebar_partials)
end

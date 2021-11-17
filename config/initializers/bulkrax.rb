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
  # config.collection_field_mapping['Bulkrax::RdfEntry'] = 'http://opaquenamespace.org/ns/set'

  # Field mappings
  # Create a completely new set of mappings by replacing the whole set as follows
  #   config.field_mappings = {
  #     "Bulkrax::OaiDcParser" => { **individual field mappings go here*** }
  #   }

  config.field_mappings = {
    'Bulkrax::CsvParser' => {
      'bulkrax_identifier' => { from: ['bulkrax_identifier'], source_identifier: true },
      'file' => { from: ['filename', 'file'], split: /\s*[|]\s*/ },
      'model' => { from: ['worktype', 'type', 'model'] },
      'title' => { from: ['title'], split: /\s*[|]\s*/ },
      'visibility' => { from: ['visibility'] },
      # 'parent' => { from: ['parent'], split: /\s*[|]\s*/ },
      'parent' => { excluded: true },
      'titleAlternative' => { from: ['titlealternative'], split: /\s*[|]\s*/ },
      'accessRights' => { from: ['accessrights'], split: /\s*[|]\s*/ },
      'accessionNumber' => { from: ['accessionnumber'], split: /\s*[|]\s*/ },
      'based_near' => { from: ['based_near', 'basednear'], split: /\s*[|]\s*/ }, # only defined on Course
      'bibliographic_citation' => { from: ['bibliographic_citation', 'bibliographiccitation'], split: /\s*[|]\s*/ }, # only defined on Course
      'boxFolder' => { from: ['boxfolder'], split: /\s*[|]\s*/ },
      'collectionCallNumber' => { from: ['collectioncallnumber'], split: /\s*[|]\s*/ },
      'contributor' => { from: ['contributor'], split: /\s*[|]\s*/ },
      'coordinates' => { from: ['coordinates'], split: /\s*[|]\s*/ },
      'creator' => { from: ['creator'], split: /\s*[|]\s*/ },
      # 'date_created' => { from: ['date_created'] }, # only defined on Course, use alt dateCreated
      'dateCreated' => { from: ['datecreated'], split: /\s*[|]\s*/ },
      'dateCreatedDisplay' => { from: ['datecreateddisplay'], split: /\s*[|]\s*/ },
      # 'date_digitized' => { from: ['date_digitized'] }, # only defined on Course and Lecture, use alt dateDigitized
      'dateDigitized' => { from: ['datedigitized'], split: /\s*[|]\s*/ },
      'dateOfSituation' => { from: ['dateofsituation'], split: /\s*[|]\s*/ },
      'datePublished' => { from: ['datepublished'], split: /\s*[|]\s*/ },
      'description' => { from: ['description'], split: /\s*[|]\s*/ },
      'descriptionAddress' => { from: ['descriptionaddress'], split: /\s*[|]\s*/ },
      'descriptionFeature' => { from: ['descriptionfeature'], split: /\s*[|]\s*/ },
      'descriptionNeighborhood' => { from: ['descriptionneighborhood'], split: /\s*[|]\s*/ },
      'descriptionStreet' => { from: ['descriptionstreet'], split: /\s*[|]\s*/ },
      'descriptionTownshipRange' => { from: ['descriptiontownshiprange'], split: /\s*[|]\s*/ },
      'digital_extent' => { from: ['digital_extent', 'digitalextent'], split: /\s*[|]\s*/ }, # only defined on Course and Lecture
      'digital_publisher_homepage' => { from: ['digital_publisher_homepage', 'digitalpublisherhomepage'], split: /\s*[|]\s*/ }, # only defined on Course and Lecture
      'displayRole' => { from: ['displayrole'], split: /\s*[|]\s*/ },
      'donorProvenance' => { from: ['donorprovenance'], split: /\s*[|]\s*/ },
      'extent' => { from: ['extent'], split: /\s*[|]\s*/ },
      'genre' => { from: ['genre'], split: /\s*[|]\s*/ },
      'identifier' => { from: ['identifier'], split: /\s*[|]\s*/ }, # only defined on Course
      'import_url' => { excluded: true },
      'independentlyDisplayed' => { from: ['independentlydisplayed'], split: /\s*[|]\s*/ },
      'itemCallNumber' => { from: ['itemcallnumber'], split: /\s*[|]\s*/ },
      'keyword' => { from: ['keyword'], split: /\s*[|]\s*/ },
      'label' => { from: ['label'], split: /\s*[|]\s*/ },
      'language' => { from: ['language'], split: /\s*[|]\s*/ },
      'license' => { from: ['license'], split: /\s*[|]\s*/ }, # only defined on Course
      'masterFilename' => { from: ['masterfilename'], split: /\s*[|]\s*/ },
      'metadataInheritance' => { from: ['metadatainheritance'], split: /\s*[|]\s*/ },
      'metadataSource' => { from: ['metadatasource'], split: /\s*[|]\s*/ },
      'originalPublisher' => { from: ['originalpublisher'], split: /\s*[|]\s*/ },
      'owner' => { excluded: true },
      'physicalDescription' => { from: ['physicaldescription'], split: /\s*[|]\s*/ },
      # 'physical_format' => { from: ['physical_format'] }, # only defined on Course and Lecture, use alt physicalFormat
      'physicalFormat' => { from: ['physicalformat'], split: /\s*[|]\s*/ },
      'publisher' => { from: ['publisher'], split: /\s*[|]\s*/ },
      'publisherHomepage' => { from: ['publisherhomepage'], split: /\s*[|]\s*/ },
      'relatedResource' => { from: ['relatedresource'], split: /\s*[|]\s*/ },
      'related_url' => { from: ['related_url', 'relatedurl'], split: /\s*[|]\s*/ }, # only defined on Course
      'relative_path' => { excluded: true },
      # 'resource_type' => { from: ['resource_type'] }, # only defined on Course and Lecture, use alt resourceType
      'resourceType' => { from: ['resourcetype'], split: /\s*[|]\s*/ },
      'rightsHolder' => { from: ['rightsholder'], split: /\s*[|]\s*/ },
      # 'rights_statement' => { from: ['rights_statement'] }, # only defined on Course, use alt rightsStatement
      'rightsStatement' => { from: ['rightsstatement', 'rights_statement'], split: /\s*[|]\s*/ },
      'rightsStatus' => { from: ['rightsstatus'], split: /\s*[|]\s*/ },
      'scale' => { from: ['scale'], split: /\s*[|]\s*/ },
      'series' => { from: ['series'], split: /\s*[|]\s*/ },
      'source' => { from: ['source'], split: /\s*[|]\s*/ },
      'staffNote' => { from: ['staffnote'], split: /\s*[|]\s*/ },
      'subject' => { from: ['subject'], split: /\s*[|]\s*/ }, # only defined on Course
      'subjectName' => { from: ['subjectname'], split: /\s*[|]\s*/ },
      'subjectPlace' => { from: ['subjectplace'], split: /\s*[|]\s*/ },
      'subjectTemporal' => { from: ['subjecttemporal'], split: /\s*[|]\s*/ },
      'subjectTitle' => { from: ['subjecttitle'], split: /\s*[|]\s*/ },
      'subjectTopic' => { from: ['subjecttopic'], split: /\s*[|]\s*/ },
      'subseries' => { from: ['subseries'], split: /\s*[|]\s*/ },
      'theme' => { from: ['theme'], split: /\s*[|]\s*/ }
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

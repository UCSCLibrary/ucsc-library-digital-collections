# frozen_string_literal: true
module Hyrax
  # An optional model mixin to define some simple properties. This must be mixed
  # after all other properties are defined because no other properties will
  # be defined once  accepts_nested_attributes_for is called
  module BasicMetadata
    extend ActiveSupport::Concern

    included do
      property :alternative_title, predicate: ::RDF::Vocab::DC.alternative

      property :label, predicate: ActiveFedora::RDF::Fcrepo::Model.downloadFilename, multiple: false

      property :relative_path, predicate: ::RDF::URI.new('http://digitalcollections.library.ucsc.edu/ontology/ns#relativePath'), multiple: false

      property :import_url, predicate: ::RDF::URI.new('http://digitalcollections.library.ucsc.edu/ontology/ns#importUrl'), multiple: false

      property :resource_type, predicate: ::RDF::Vocab::DC.type

      property :creator, predicate: ::RDF::Vocab::DC11.creator

      property :contributor, predicate: ::RDF::Vocab::DC11.contributor

      property :description, predicate: ::RDF::Vocab::DC11.description

      property :abstract, predicate: ::RDF::Vocab::DC.abstract

      property :keyword, predicate: ::RDF::Vocab::SCHEMA.keywords

      # Used for a license
      property :license, predicate: ::RDF::Vocab::DC.license, multiple: true

      # This is for the rights statement
      property :rightsStatement, predicate: ::RDF::Vocab::EDM.rights

      property :rights_notes, predicate: ::RDF::URI.new('http://purl.org/dc/elements/1.1/rights'), multiple: true

      property :accessRights, predicate: ::RDF::Vocab::DC.accessRights

      property :publisher, predicate: ::RDF::Vocab::DC11.publisher

      property :dateCreated, predicate: ::RDF::Vocab::DC.date

      property :subject, predicate: ::RDF::Vocab::DC11.subject

      property :language, predicate: ::RDF::Vocab::DC11.language

      property :identifier, predicate: ::RDF::Vocab::DC.identifier

      property :based_near, predicate: ::RDF::Vocab::FOAF.based_near, class_name: Hyrax::ControlledVocabularies::Location

      property :related_url, predicate: ::RDF::RDFS.seeAlso

      property :bibliographic_citation, predicate: ::RDF::Vocab::DC.bibliographicCitation

      property :source, predicate: ::RDF::Vocab::DC.source

      #These are custom properties added for collections
      property :harmfulLanguageStatement, predicate: ::RDF::URI('http://digitalcollections.library.ucsc.edu/ontology/harmfulLanguageStatement')

      property :collectionCallNumber, predicate: ::RDF::URI('http://digitalcollections.library.ucsc.edu/ontology/collectionCallNumber')

      property :extent, predicate: ::RDF::Vocab::DC.extent

      property :donorProvenance, predicate: ::RDF::Vocab::DC.provenance

      property :publisherHomepage, predicate: ::RDF::Vocab::FOAF.homepage

      property :rightsHolder, predicate: ::RDF::Vocab::DC.rightsHolder

      property :rightsStatus, predicate: ::RDF::Vocab::DC.license

      property :subjectName, predicate: ::RDF::Vocab::FOAF.name

      property :subjectPlace, predicate: ::RDF::Vocab::DC.spatial

      property :subjectTopic, predicate: ::RDF::Vocab::DC.subject

      property :subjectTitle, predicate: ::RDF::Vocab::MODS.subjectTitle

      property :dateCreated, predicate: ::RDF::Vocab::BF2.creationDate

      property :dateCreatedDisplay, predicate: ::RDF::Vocab::MODS.dateCreated  

      property :dateCreatedIngest, predicate: ::RDF::Vocab::DC.created

      property :label, predicate: ActiveFedora::RDF::Fcrepo::Model.downloadFilename, multiple: false

      property :relative_path, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#relativePath'), multiple: false

      property :import_url, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#importUrl'), multiple: false

      property :descriptionNeighborhood, predicate: ::RDF::URI.new('http://scholarsphere.psu.edu/ns#descriptionNeighborhood'), multiple: false

      schema = ScoobySnacks::METADATA_SCHEMA
      schema.fields.values.each do |field|
        # Define the property and its indexing unless it is already defined (e.g. in hyrax core)
        unless respond_to? field.name.to_sym
          property field.name.to_sym, {predicate: field.predicate, multiple: field.multiple?}  do |index| 
            index.as *field.solr_descriptors
            index.type field.solr_data_type
          end
        end
      end

      id_blank = proc { |attributes| attributes[:id].blank? }

      class_attribute :controlled_properties
      self.controlled_properties = schema.controlled_field_names.map(&:to_sym) | [:based_near]
      self.controlled_properties.each do |controlled_property|
        accepts_nested_attributes_for controlled_property, reject_if: id_blank, allow_destroy: true
      end
    end
  end
end

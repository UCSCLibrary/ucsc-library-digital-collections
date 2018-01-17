module Ucsc
  class WorkIndexer < Hyrax::WorkIndexer
    #    include Ucsc::IndexesLinkedMetadata

    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc = index_controlled_fields(solr_doc)
      end
    end

    def index_controlled_fields(solr_doc)
      return unless object.persisted?
      object.controlled_properties.each do |property|
        solr_doc[label_field(property)] = []
        solr_doc[Solrizer.solr_name(property)] = []

        object[property] = Array(object[property]) if !object[property].kind_of?(Array)
        object[property].each do |val|
          case val
          when ActiveTriples::Resource
            fetch_remote_label(val)
            solr_doc[label_field(property)] << val.rdf_label.first.to_s
            solr_doc[Solrizer.solr_name(property)] << val.id
          when String
            solr_doc[label_field(property)] = val
          else
            raise ArgumentError, "Can't handle #{val.class}"
          end
        end

      end
      solr_doc
    end

    def fetch_remote_label(resource)
      #TODO right now it only fetches the label once per resource. 
      # it should be able to re-index on command.
      return if resource.rdf_label != resource.id
      Rails.logger.info "Fetching #{resource.rdf_subject} from the authorative source. (this is slow)"
      resource.fetch(headers: { 'Accept'.freeze => default_accept_header })
    rescue IOError, SocketError => e
      # IOError could result from a 500 error on the remote server
      # SocketError results if there is no server to connect to
      Rails.logger.error "Unable to fetch #{resource.rdf_subject} from the authorative source.\n#{e.message}"
    end

    def default_accept_header
      RDF::Util::File::HttpAdapter.default_accept_header.sub(/, \*\/\*;q=0\.1\Z/, '')
    end

    def label_field(property)
      Solrizer.solr_name("#{property}_label")
    end

  end
end

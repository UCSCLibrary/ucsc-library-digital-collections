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
        # resolve from QA endpoints!

        object[property] = Array(object[property]) if !object[property].kind_of?(Array)
        object[property].each do |val|
          case val
          when ActiveTriples::Resource
            if needs_indexing?(object)
              label = fetch_remote_label(val)
            else
              label = get_existing_index(object) unless needs_indexing?(object)
            end

            solr_doc[label_field(property)] << label
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

    def needs_indexing?(obj)
      return true if obj.last_reconciled.nil? or obj.date_modified.nil?
      return true if obj.last_reconciled < 6.months.ago
#      return true if obj.last_reconciled < 2.hours.ago
      return true if obj.last_reconciled < obj.date_modified
    end

    def get_existing_index(obj,property)
      query = ActiveFedora::SolrQueryBuilder.construct_query_for_ids([obj.id])
      solr_response = ActiveFedora::SolrService.get(query)
      sd = SolrDocument.new(solr_response['response']['docs'].first, solr_response)
      label = sd[label_field(property)]
    end


    def fetch_remote_label(resource)
      Rails.logger.info "Fetching #{resource.rdf_subject} from the authorative source. (this is slow)"
      if resource.id.include? "ucsc.edu" 
        url = resource.id.gsub("digital-collections.library.ucsc.edu","localhost")
        Rails.logger.debug("Fetching label from QA url: #{url}")
        label = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)["term"]
      else
        resource.fetch(headers: { 'Accept'.freeze => default_accept_header })
        return resource.rdf_label.first.to_s
      end
    rescue Exception => e
      # IOError could result from a 500 error on the remote server
      # SocketError results if there is no server to connect to
      Rails.logger.error "Unable to fetch #{resource.rdf_subject} from the authorative source.\n#{e.message}"
      return "Cannot find term"
    end

    def default_accept_header
      RDF::Util::File::HttpAdapter.default_accept_header.sub(/, \*\/\*;q=0\.1\Z/, '')
    end

    def label_field(property)
      Solrizer.solr_name("#{property}_label")
    end

  end
end

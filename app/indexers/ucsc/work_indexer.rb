require 'nokogiri'
require 'open-uri'
module Ucsc
  class WorkIndexer < Hyrax::WorkIndexer
    #    include Ucsc::IndexesLinkedMetadata

    class << self
      attr_accessor :last_buffer_reset
      attr_accessor :ld_buffer
    end
    @last_buffer_reset = DateTime.now
    @ld_buffer = {}

    def initialize(args=nil)
      self.class.last_buffer_reset = DateTime.now
      self.class.ld_buffer = {}
      super args
    end

    def generate_solr_document
      super.tap do |solr_doc|
        solr_doc = index_controlled_fields(solr_doc)
        solr_doc = merge_subjects(solr_doc)
      end
    end

    def merge_subjects(solr_doc)
      subject_fields = ["subjectTopic","subjectName","subjectTemporal","subjectPlace"]
      subjects = []
      subject_fields.each{ |subject_field| subjects.concat(solr_doc[Solrizer.solr_name(subject_field)]) }
      solr_doc[Solrizer.solr_name('subject')] = subjects
      solr_doc
    end

    def index_controlled_fields(solr_doc)
      return unless object.persisted?

      object.controlled_properties.each do |property|
        # Move on if the property does not need to be reconciled (saves time)
        next unless needs_reconciliation?(object,solr_doc, property)

        # Clear old values from the solr document
        solr_doc[label_field(property)] = []
        solr_doc[Solrizer.solr_name(property)] = []

        # Wrap single objects in arrays if necessary (though it shouldn't be)
        object[property] = Array(object[property]) if !object[property].kind_of?(Array)

        # Loop through the different values provided for this property
        object[property].each do |val|
          case val
         when ActiveTriples::Resource
            # We need to fetch the string from an external vocabulary
            solr_doc[label_field(property)] << fetch_remote_label(val)
            solr_doc[Solrizer.solr_name(property)] << val.id
          when String
            # This is just a normal string (from a legacy model, etc)
            # Set the label index to the string for now
            # In the future, we will create a new entry in 
            # the appropriate local vocab
            solr_doc[label_field(property)] << val
            solr_doc[Solrizer.solr_name(property)] << val
          else
            raise ArgumentError, "Can't handle #{val.class}"
          end
        end
      end
      solr_doc
    end

    def needs_reconciliation?(obj, solr_doc, property)

      #first, definitely reconcile if the object is brand new
      return true if obj.id.nil?

      # Next, reconcile if we can't find the solr document for any reason
      begin
        old_solr_doc = SolrDocument.find(obj.id)
      rescue RuntimeError => e
        return true
      end

      new_solr_doc = SolrDocument.new(solr_doc)
      last_reconciled = old_solr_doc.last_reconciled
      
      # Index if it was never reconciled or is newly created
      return true if last_reconciled.blank?

      # Index if it was last reconciled more than 6 months ago
      return true if last_reconciled < 6.months.ago

      # Do not reconcile if the property is unchanged
      return false if old_solr_doc.send(property).sort == new_solr_doc.send.property.sort

      # Do not reconcile if the property is unchanged and a string
      return false if old_solr_doc.send(property+"_label").sort == new_solr_doc.send(property).sort

      # Otherwise, go ahead and index
      return true
    end

    def fetch_remote_label(resource)

      # Reset buffer if it is old
      if DateTime.now - self.class.last_buffer_reset > 6.months
        self.class.ld_buffer = {} if DateTime.now - self.class.last_buffer_reset > 6.months
        self.class.last_buffer_reset = DateTime.now
      end

      # Return key from buffer if it exists already
      return self.class.ld_buffer[resource.id] if self.class.ld_buffer.key?(resource.id)
        
      Rails.logger.info "Fetching #{resource.rdf_subject} from the authorative source. (this is slow)"
      # Check if it's a local resource
      if resource.id.include? "ucsc.edu" 
        # Swap in 'localhost' to reconcile from staging, dev, etc
        url = resource.id.gsub("digital-collections.library.ucsc.edu","localhost")
        Rails.logger.debug("Fetching label from QA url: #{url}")
        label = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)["term"]
        
      elsif resource.id.include? "geonames.org"
        unless (res_url = resource.id).include? "/about.rdf"
          res_url = File.join(resource.id,'about.rdf')
        end
        puts "resource id (url): #{res_url}"
        doc = Nokogiri::XML(open(res_url))
        label = doc.xpath('//gn:name').first.children.first.text
      else
        # Fetch the resource from its url
        resource.fetch(headers: { 'Accept'.freeze => default_accept_header })
        label = resource.rdf_label.first.to_s
      end
      
      # Trim the first entry from the buffer if it is getting large
      self.class.ld_buffer.except!(self.class.ld_buffer.keys.first) if self.class.ld_buffer.size > 2000
      # Add this to the buffer 
      self.class.ld_buffer[resource.id] = label
      return label
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

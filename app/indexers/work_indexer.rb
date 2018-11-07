require 'nokogiri'
require 'open-uri'
class WorkIndexer < Hyrax::WorkIndexer

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc = index_controlled_fields(solr_doc)
      solr_doc = merge_subjects(solr_doc)
    end
  end

  def merge_subjects(solr_doc)
    subject_fields = ["subjectTopic","subjectName","subjectTemporal","subjectPlace"]
    subjects = []
    subject_fields.each{ |subject_field| subjects.concat( solr_doc[label_field(subject_field)]) if solr_doc[label_field(subject_field)] }
    solr_doc[label_field("subject")] = subjects
    solr_doc
  end

  def index_controlled_fields(solr_doc)
    return unless object.persisted?

    object.controlled_properties.each do |property|

      # Clear old values from the solr document
      solr_doc.delete label_field(property)
      solr_doc.delete Solrizer.solr_name(property)

      # Wrap single objects in arrays if necessary (though it shouldn't be)
      object[property] = Array(object[property]) if !object[property].kind_of?(Array)

      # Loop through the different values provided for this property
      object[property].each do |val|
        solr_doc[label_field(property)] ||= []
        case val
        when ActiveTriples::Resource
          # We need to fetch the string from an external vocabulary
          solr_doc[label_field(property)] << self.class.fetch_remote_label(val)
        when String
          # This is just a normal string (from a legacy model, etc)
          # Set the label index to the string for now
          # In the future, we will create a new entry in 
          # the appropriate local vocab
          solr_doc[label_field(property)] << val
        else
          raise ArgumentError, "Can't handle #{val.class}"
        end
      end
    end
    solr_doc
  end

  def self.fetch_remote_label(url)
    if url.is_a? ActiveTriples::Resource
      resource = url
      url = resource.id 
    end
    begin
      if url.to_s.include?("ucsc.edu")
        Rails.logger.info "handling as ucsc resource"

        # TODO replace hard-coded URLs
        # Swap for correct hostname in non-prod environments
        case ENV['RAILS_ENV']
        when 'staging'
          (uri = URI(url.gsub("digitalcollections.library","digitalcollections-staging.library").gsub("https://","http://")))
        when 'development'
          (uri = URI(url.gsub("digitalcollections.library.ucsc.edu","localhost"))).port=(3000) 
        else
          uri = URI(url)
        end

        label = JSON.parse(Net::HTTP.get_response(uri).body)["label"]

      # handle geonames specially
      elsif url.include? "geonames.org"
        unless (res_url = url).include? "/about.rdf"
          res_url = File.join(url,'about.rdf')
        end
        doc = Nokogiri::XML(open(res_url))
        label = doc.xpath('//gn:name').first.children.first.text

      # fetch from other normal authorities
      else
        resource ||= ActiveTriples::Resource.new(url)
        label = resource.fetch(headers: { 'Accept'.freeze => default_accept_header }).first.to_s
      end
      
      LdBuffer.create(url: url, label: label)
      # Delete oldest records if we have more than 5K in the buffer
      if (cnt = LdBuffer.count - 5000) > 0
        ids = LdBuffer.order('created_at DESC').limit(cnt).pluck(:id)
        LdBuffer.where(id: ids).delete_all
      end
      
      return label

    rescue Exception => e
      # IOError could result from a 500 error on the remote server
      # SocketError results if there is no server to connect to
      Rails.logger.error "Unable to fetch #{url} from the authorative source.\n#{e.message}"
      return "Cannot find term"
    end
  end
    
  def self.default_accept_header
    RDF::Util::File::HttpAdapter.default_accept_header.sub(/, \*\/\*;q=0\.1\Z/, '')
  end
  
  def label_field(property)
    Solrizer.solr_name("#{property}_label")
  end
  
end

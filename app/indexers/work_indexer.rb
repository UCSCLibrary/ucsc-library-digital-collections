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
    subject_fields.each{ |subject_field| subjects.concat( solr_doc[label_field(subject_field)]) }
    solr_doc[label_field("subject")] = subjects
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

    buf = LdBuffer.where(url: resource.id).order(created_at: :desc).first

    # Return the buffered value if it's up to date
    # Destroy it if it's obsolete
    unless buf.nil?
      if buf.created_at > DateTime.now - 6.months
        return buf.label
      else
        buf.destroy!
      end
    end
    
    Rails.logger.info "Fetching #{resource.rdf_subject} from the authorative source. (this is slow)"

    # Check if it's a local resource
    if resource.rdf_subject.to_s.include?("ucsc.edu")
      Rails.logger.info "handling as ucsc resource"

      # TODO replace hard-coded URLs
      # Swap for correct hostname in non-prod environments
      case ENV['RAILS_ENV']
      when 'staging'
        (uri = URI(resource.id.gsub("digitalcollections.library","digitalcollections-staging.library").gsub("https://","http://")))
      when 'development'
        (uri = URI(resource.id.gsub("digitalcollections.library.ucsc.edu","localhost"))).port=(3000) 
      else
        uri = URI(resource.id)
      end

      label = JSON.parse(Net::HTTP.get_response(uri).body)["label"]

    # handle geonames specially
    elsif resource.id.include? "geonames.org"
      unless (res_url = resource.id).include? "/about.rdf"
        res_url = File.join(resource.id,'about.rdf')
      end
      doc = Nokogiri::XML(open(res_url))
      label = doc.xpath('//gn:name').first.children.first.text

    # fetch from other normal authorities
    else
      resource.fetch(headers: { 'Accept'.freeze => default_accept_header })
      label = resource.rdf_label.first.to_s
    end
    
    LdBuffer.create(url: resource.id, label: label)

    # Delete oldest records if we have more than 5K in the buffer
    if (cnt = LdBuffer.count - 5000) > 0
      ids = LdBuffer.order('created_at DESC').limit(cnt).pluck(:id)
      LdBuffer.where(id: ids).delete_all
    end

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

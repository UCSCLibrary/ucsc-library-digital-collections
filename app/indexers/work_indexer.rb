require 'nokogiri'
require 'open-uri'
class WorkIndexer < Hyrax::WorkIndexer

  def generate_solr_document
    super.tap do |solr_doc|
      solr_doc = index_controlled_fields(solr_doc)
      solr_doc = merge_fields(:subject, [:subjectTopic,:subjectName,:subjectTemporal,:subjectPlace], solr_doc)
      solr_doc = merge_fields(:callNumber, [:itemCallNumber,:collectionCallNumber,:boxFolder], solr_doc)
      solr_doc = merge_title_fields(:titleDisplay, solr_doc)
    end
  end

  def schema
    ScoobySnacks::METADATA_SCHEMA
  end

  def merge_fields(merged_field_name, fields_to_merge, solr_doc)
    merged_field_contents = []
    fields_to_merge.each do |field_name|
      field = schema.get_field(field_name.to_s)
      if (indexed_field_contents = solr_doc[field.solr_search_name])
        merged_field_contents.concat(indexed_field_contents)
      end
    end
    solr_doc[Solrizer.solr_name(merged_field_name)] = merged_field_contents
    return solr_doc
  end

  def merge_title_fields(merged_field_name, solr_doc)
    # If there is a value in the Title or TitleAlternative fields 
    # this is not blank or a variant of "untitled", return that
    titles = Array(solr_doc[schema.get_field(:title).solr_name]) + Array(solr_doc[schema.get_field(:titleAlternative).solr_name])
    titles.each{ |title| return title unless (title.blank? or title.downcase.include?("untitled") ) }
    # Otherwise, look to the subseries and series, and merge them if we have both
    subseries = solr_doc[schema.get_field(:subseries).solr_name]
    series = solr_doc[schema.get_field(:subseries).solr_name]
    title = ""
    unless subseries.blank?
      title = subseries.first
    end
    unless series.blank?
      title += ' - ' unless title.blank?
      title += series.first
    end
    return title unless title.blank?
    
  end

  def index_controlled_fields(solr_doc)
    return unless object.persisted?

    schema.controlled_field_names.each do |field_name|
      field = schema.get_field(field_name)

      # Clear old values from the solr document
      solr_doc.delete field.solr_search_name
      solr_doc.delete field.solr_facet_name if field.facet?
      solr_doc.delete field.solr_sort_name if field.sort?

      # Wrap single objects in arrays if necessary (though it shouldn't be)
      object[field_name] = Array(object[field_name]) if !object[field_name].kind_of?(Array)

      # Loop through the different values provided for this property
      object[field_name].each do |val|
        label = ""
        case val
        when ActiveTriples::Resource
          # We need to fetch the string from an external vocabulary
          label = self.class.fetch_remote_label(val)
          # skip indexing this one if we can't retrieve the label
          next unless label
        when String
          # This is just a normal string (from a legacy model, etc)
          # Go ahead and create a new entry in the appropriate local vocab, if there is one
          auth_name = field.vocabularies.find{|vocab| vocab['authority'].to_s.downcase == 'local'}['subauthority']
          mintLocalAuthUrl(auth_name, val) if auth_name.present?
          label = val
        else
          raise ArgumentError, "Can't handle #{val.class}"
        end
        (solr_doc[field.solr_search_name] ||= []) << label
        (solr_doc[field.solr_facet_name] ||= [])  << label if field.facet?
        (solr_doc[field.solr_sort_name] ||= [])  << label if field.sort?
      end
    end
    solr_doc
  end

  def mintLocalAuthUrl(auth_name, value) 
    id = value.parameterize
    auth = Qa::LocalAuthority.find_or_create_by(name: auth_name)
    entry = Qa::LocalAuthorityEntry.create(local_authority: auth,
                                           label: value,
                                           uri: id)
    return localIdToUrl(id,auth_name)
  end

  def localIdToUrl(id,auth_name) 
    return "https://digitalcollections.library.ucsc.edu/authorities/show/local/#{auth_name}/#{id}"
  end

  def self.fetch_remote_label(url)
    if url.is_a? ActiveTriples::Resource
      resource = url
      url = resource.id 
    end
    
    # if it's buffered, return the buffer
    if (buffer = LdBuffer.find_by(url: url))
      if (Time.now - buffer.updated_at).seconds > 1.year
        buffer.destroy
      else
        return buffer.label
      end
    end

    begin
      if url.to_s.include?("ucsc.edu")
        Rails.logger.info "handling as ucsc resource"
        # TODO replace hard-coded URLs
        # Swap for correct hostname in non-prod environments
        case ENV['RAILS_ENV']
        when 'staging'
          (uri = URI(url.gsub("digitalcollections.library","digitalcollections-staging.library").gsub("https://","http://")))
        when 'development', 'test'
#          (uri = URI(url.gsub("digitalcollections.library.ucsc.edu","localhost"))).port=(3000) 
          uri = URI(url.gsub("https://digitalcollections.library.ucsc.edu","http://localhost"))
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
        labels = resource.fetch(headers: { 'Accept'.freeze => default_accept_header }).rdf_label
        if labels.count == 1
          label = labels.first
        else
          label = labels.find{|label| label.language.to_s =~ /en/ }.to_s
        end
      end
      
      Rails.logger.info "Adding buffer entry - label: #{label}, url:  #{uri.to_s}"
      LdBuffer.create(url: url, label: label)

      # Delete oldest records if we have more than 5K in the buffer
      if (cnt = LdBuffer.count - 5000) > 0
        ids = LdBuffer.order('created_at DESC').limit(cnt).pluck(:id)
        LdBuffer.where(id: ids).delete_all
      end
      
      if label == url && url.include?("id.loc.gov")
        #handle weird alternative syntax
        response = JSON.parse(Net::HTTP.get_response(uri).body)
        response.each do |index, node|
          if node["@id"] == url
            label = node["http://www.loc.gov/mads/rdf/v1#authoritativeLabel"].first["@value"]
          end
        end
      end

      raise Exception if label == url

      return label

    rescue Exception => e
      # IOError could result from a 500 error on the remote server
      # SocketError results if there is no server to connect to
      Rails.logger.error "Unable to fetch #{url} from the authorative source.\n#{e.message}"
      return false
    end
  end
    
  def self.default_accept_header
    RDF::Util::File::HttpAdapter.default_accept_header.sub(/, \*\/\*;q=0\.1\Z/, '')
  end
    
end

module ControlledIndexerBehavior
  extend ActiveSupport::Concern


  class_methods do

    def sanitize_url(url)
      cleaned_url = url.dup
      # Geonames: fetch rdf not the html
      if url.include?("geonames.org")
        if url =~ /geonames.org\/[0-9]+.*\z/ && !url.include?("/about.rdf")
          cleaned_url = url.gsub(/(geonames.org\/[0-9]+).*\z/,"\\1/about.rdf")
        end
        cleaned_url
      # Getty
      elsif url.include?("vocab.getty.edu")
        cleaned_url = cleaned_url.gsub("/page/","/")
        cleaned_url = cleaned_url.gsub('http://','https://')
      # Library of Congress
      elsif (url.include?("id.loc.gov") || url.include?("info:lc"))
        cleaned_url = cleaned_url.gsub("info:lc","http://id.loc.gov")
        cleaned_url = cleaned_url.gsub('http://','https://')
        cleaned_url += '.html'
      # In the local dev env the host is the container ID, change to localhost
      elsif url.include?("authorities/show/local") && !url.include?("library.ucsc.edu")
        cleaned_url = cleaned_url.gsub(/http:\/\/[a-z0-9]+\//,"http://localhost:3000/")
      else
        cleaned_url
      end
    end

    def fetch_remote_label(url)
      if url.is_a? ActiveTriples::Resource
        resource = url
        url = resource.id.dup
      end
      # if it's buffered, return the buffer
      if (buffer = LdBuffer.find_by(url: url))
        if (Time.now - buffer.updated_at).seconds > 1.year
          LdBuffer.where(url: url).each{|buffer| buffer.destroy }
        else
          return buffer.label
        end
      end
    begin
      cleaned_url = sanitize_url(url.dup)

      # Hostname varies for local vocabs, use path to identify
      if url.to_s.include?("authorities/show/local")
        label = JSON.parse(Net::HTTP.get_response(URI(cleaned_url)).body)["label"]
      elsif url.include? "geonames.org"
        doc = Nokogiri::XML(open(cleaned_url))
        label = doc.xpath('//gn:name').first.children.first.text.dup
      elsif url.include?("vocab.getty.edu")
        response = Net::HTTP.get_response(URI(cleaned_url))
        res = Nokogiri::HTML.parse(response.body)
        label = res.title.strip
      elsif (url.include?("id.loc.gov") || url.include?("info:lc"))
        response = Net::HTTP.get_response(URI(cleaned_url))
        res = Nokogiri::HTML.parse(response.body)
        label = res.title.split(' - ')[0].strip
      else
        # Smoothly handle some common syntax issues
        if !cleaned_url.is_a? String
          resource = ActiveTriples::Resource.new(cleaned_url)
          labels = resource.fetch(headers: { 'Accept'.freeze => default_accept_header }).rdf_label
          if labels.count == 1
            label = labels.first.dup.to_s
          else
            label = labels.find{|label| label.language.to_s =~ /en/ }.dup.to_s
          end
        else
          label = cleaned_url
        end
      end

      Rails.logger.info "Adding buffer entry - label: #{label}, url:  #{url.to_s}"
      LdBuffer.create(url: url, label: label)

      # Delete oldest records if we have more than 5K in the buffer
      if (cnt = LdBuffer.count - 5000) > 0
        ids = LdBuffer.order('created_at ASC').limit(cnt).pluck(:id)
        LdBuffer.where(id: ids).delete_all
      end
      raise Exception if label.to_s == url.to_s

      return label.to_s

      rescue Exception => e
        # IOError could result from a 500 error on the remote server
        # SocketError results if there is no server to connect to
         Rails.logger.error "Unable to fetch #{cleaned_url} from the authorative source.\n#{e.message}"
         return false
      end
    end

    private

    def destroy_buffer(url)
      LdBuffer.where(url: url).each{|buffer| buffer.destroy }
    end
    
    def default_accept_header
      RDF::Util::File::HttpAdapter.default_accept_header.sub(/, \*\/\*;q=0\.1\Z/, '')
    end

  end

  def index_controlled_fields(solr_doc)
    return solr_doc unless object.persisted?

    schema.controlled_field_names.each do |field_name|
      field = schema.get_field(field_name)

      # Clear old values from the solr document
      solr_doc.delete Solrizer.solr_name(field_name)
      solr_doc.delete Solrizer.solr_name(field_name.to_sym)
      field.solr_names.each do |solr_name| 
        solr_doc.delete(solr_name)
        solr_doc.delete(solr_name.to_sym)
      end

      # Wrap single objects in arrays if necessary (though it shouldn't be)
      #      object[field_name] = Array.wrap(object[field_name])

      # Loop through the different values provided for this property
      object[field_name].each do |val|
        label = ""
        case val
        when ActiveTriples::Resource, URI::regexp
          # We need to fetch the string from an external vocabulary
          label = ::WorkIndexer.fetch_remote_label(val)
          # skip indexing this one if we can't retrieve the label
          next unless label
        when String
          # This is just a normal string (from a legacy model, etc)
          # Go ahead and create a new entry in the appropriate local vocab, if there is one
          subauth_name = get_subauthority_for(field: field, authority_name: 'local')
          # Don't index if we're missing subauthority or the value is blank
          next unless subauth_name.present? && !val.blank?
          mint_local_auth_url(subauth_name, val) if subauth_name.present?
          label = val
        else
          raise ArgumentError, "Can't handle #{val.class} as a metadata term"
        end
        field.solr_names.each do |solr_name| 
          (solr_doc[solr_name] ||= []) << label
        end
      end
    end
    solr_doc
  end

  def get_subauthority_for(field:, authority_name:)
    field_vocab = field.vocabularies.find { |vocab| vocab['authority'].to_s.downcase == authority_name }
    return unless field_vocab.present?

    field_vocab['subauthority']
  end

  def mint_local_auth_url(subauth_name, value)
    id = value.parameterize
    auth = Qa::LocalAuthority.find_or_create_by(name: subauth_name)

    Qa::LocalAuthorityEntry.find_or_create_by!(uri: id) do |entry|
      entry.local_authority = auth
      entry.label = value
    end

    local_id_to_url(id, subauth_name)
  end

  def local_id_to_url(id, subauth_name)
    "#{CatalogController.root_url}/authorities/show/local/#{subauth_name}/#{id}"
  end
end

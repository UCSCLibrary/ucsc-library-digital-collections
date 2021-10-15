require 'socket'
# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocument

  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  # Adds ScoobySnacks metadata attribute definitions
  include ScoobySnacks::SolrBehavior

  # Adds custom attributes for collections
  attribute :collection_call_number, Solr::Array, solr_name('collection_call_number')
  attribute :extent, Solr::Array, solr_name('extent')
  attribute :donor_provenance, Solr::Array, solr_name('donor_provenance')
  attribute :publisher_homepage, Solr::Array, solr_name('publisher')
  attribute :rights_holder, Solr::Array, solr_name('rights_holder')
  attribute :rights_status, Solr::Array, solr_name('rights_status')
  attribute :subject_name, Solr::Array, solr_name('subject_name')
  attribute :subject_place, Solr::Array, solr_name('subject_place')
  attribute :subject_topic, Solr::Array, solr_name('subject_topic')
  attribute :subject_title, Solr::Array, solr_name('subject_title')
  attribute :date_created_display, Solr::Array, solr_name('date_created_display')
  attribute :harmful_language_statement, Solr::String, solr_name('harmful_language_statement')
  attribute :subject_terms, Solr::Array, solr_name('subject_terms')


 def self.add_field_semantics(label,solr_name,schema=nil)
    label = "#{schema}:#{label}" if schema
    field_semantics.merge!(label => Array.wrap(solr_name)) {|key, old_val, new_val| Array.wrap(old_val) + Array.wrap(new_val)}
  end

  # add collection membership in OAI-PMH feed source element for all schemas
  add_field_semantics('source','member_of_collections_ssim')

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)
  use_extension(Ucsc::Blacklight::Dpla)

  # Do content negotiation for AF models. 

  use_extension( Hydra::ContentNegotiation )


  # create field semantics hash from oai.yml file
  oai_namespaces =  YAML.load_file(File.join(Rails.root.to_s,'config/oai.yml'))
  oai_namespaces.each do |namespace, properties|
    next if namespace.to_s.downcase == "default"
    if properties["parent_schema"].present? && (parent = oai_namespaces[properties["parent_schema"]]).present?
      properties = parent.deep_merge(properties).reject{|key,value| key == "parent_schema"}
    end
    properties.each do |property,field_names|
      field_names.each do |field_name|
        add_field_semantics(property, field_name, namespace)
      end
    end
  end

  def title
    schema = ScoobySnacks::METADATA_SCHEMA
    title_solr_name = schema.get_field('title').solr_name
    subseries_solr_name = schema.get_field('subseries').solr_name
    titles = self[title_solr_name]
    # return the normal titles unless the work is untitled
    return titles unless  titles.blank? or titles.all?{|title| title.downcase.strip == "untitled"}
    # The work must be untitled
    subseries = self[subseries_solr_name]
    # Tack on a subseries if we have one
    if subseries.present?
      return ["Untitled: #{subseries.first}"]
    end
    # Return "Untitled" if there is no title and no subseries
    return ["Untitled"]
  end

  def visibility
    return "request" if self["visibility_ssi"] == "request"
    return "campus" if self["visibility_ssi"] == "campus"
    super
  end

  def to_semantic_values(schema="dc")
    (@semantic_value_hash ||= {})[schema] ||= self.class.field_semantics.each_with_object(Hash.new([])) do |(key, field_names), hash| 

      if (val_schema, attribute = key.split(':')).length == 2
        # Skip this one unless it is in the right schema
        # (or if we are requesting all schemas, or if it is registered without a specific schema)
        next unless schema.blank? || val_schema.blank? || (schema.to_s.downcase == val_schema.to_s.downcase)
        key = attribute
      end
      
      ##
      # Handles single string field_name or an array of field_names
      value = Array.wrap(field_names).map do |field_name| 
        raw_value = self.send(field_name) if self.respond_to?(field_name.to_sym)
        raw_value = self[field_name] if raw_value.blank? and self[field_name].present?
        raw_value
      end
      
      value = value.flatten.compact
      hash[key] = value unless value.empty?
    end
  end

  def permalink(record = self)
    "#{root_url}/records/#{record.id}"
  end

  def display_image_url(size: "800,")
    if representative_id.present? && (representative_id != id)
      SolrDocument.find(representative_id).display_image_url(size: size)
    elsif !image?
      thumbnail_path
    elsif self['hasRelatedImage_ssim'].present?
      Hyrax.config.iiif_image_url_builder.call(self['hasRelatedImage_ssim'].first,"nil",size)
    elsif self['relatedImageId_ss'].present?
      Hyrax.config.iiif_image_url_builder.call(self['relatedImageId_ss'],"nil",size)
    elsif human_readable_type.downcase.include? "file"
      Hyrax.config.iiif_image_url_builder.call(id,"nil",size)
    else
      nil
    end
  end

  def is_type?(type)
    return false unless ["audio","video","image"].include? type.to_s
  end

  def audio?
    #todo index this
    return true if FileSet.audio_mime_types.include? mime_type
    return true if resourceType.any?{|restype| ["audio","sound"].include? restype.to_s.downcase}
    return true if file_set_ids.any?{|id| SolrDocument.find(id).audio?}  
    member_work_ids.present? && member_work_ids.all?{|id| SolrDocument.find(id).audio?}
  end
 
  def image?
    #todo index this
    return true if super
    return true if FileSet.image_mime_types.include? mime_type
    return true if resourceType.any?{|restype| ["photograph","image","picture","photo"].include? restype.to_s.downcase}
    return true if file_set_ids.any?{|id| SolrDocument.find(id).image?}  
    member_work_ids.present? && member_work_ids.all?{|id| SolrDocument.find(id).image?}
  end

  def root_url
    "https://"+Socket.gethostname
  end

  def ancestor_ids
    fetch('ancestor_ids_ssim',[])
  end
    
  def member_ids
    fetch('member_ids_ssim', [])
  end

  def ordered_member_ids
    member_ids
  end

  def member_work_ids
    member_ids - file_set_ids
  end

  def file_set_ids
    fetch('file_set_ids_ssim', [])
  end

  def file_sets
    @file_sets ||= file_set_ids.map{|id| SolrDocument.find(id)}
  end

  def date_digitized
    self[Solrizer.solr_name('date_digitized')]
  end

  def physical_format
    self[Solrizer.solr_name('physical_format')]
  end

  def digital_extent
    self[Solrizer.solr_name('digital_extent')]
  end

  def digital_publisher_homepage
    self[Solrizer.solr_name('digital_publisher_homepage')]
  end

  def parent_course
    return nil if human_readable_type != "Lecture"
    return @parent_course_solr_document unless @parent_course_solr_document.nil?
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("member_ids" => id, "has_model" => "Course")
    response = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 1})["response"]["docs"][0]
    return nil if response.nil?
    @parent_course_solr_document = SolrDocument.new(response)
  end

  def parent_works
    return @parent_work_solr_documents unless @parent_work_solr_documents.nil?
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("file_set_ids" => id, "member_ids" => id).gsub('AND','OR')
    response = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 1})["response"]["docs"]
    return nil if response.nil?
    @parent_work_solr_documents = response.map{|doc| SolrDocument.new(doc)}
  end

  def parent_work
    parent_works.first
  end

  def parent_work_ids
    parent_works.map{|wrk| wrk.id}
  end

  def parent_work_id
    return nil unless parent_work.present? 
    parent_work.id
  end

  def parent_id
    parent_work_id
  end

  def sibling_work_ids
    parent_works.reduce([]){|siblings,parent| siblings += parent.ordered_ids} - [id]
  end

  def sibling_works
    sibling_works.map(SolrDocument.find(sibling_work_ids))
  end

  def grandchild_file_set_ids
    self["grandchild_file_set_ids_ssm"] || []
  end

end

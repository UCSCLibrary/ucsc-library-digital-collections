# Generated via
#  `rails generate hyrax:work Work`
class Work < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Bulkrax::Metadata

  #overwrite date_modified property so as not to conflict with dateDigitized
  property :date_modified, predicate: ::RDF::URI.new("http://digitalcollections.library.ucsc.edu/ontology/modified"), multiple: false do |index|
    index.type :date
    index.as :stored_sortable
  end

#  include ::Hyrax::BasicMetadata

  include ::ScoobySnacks::WorkModelBehavior

  include ::Ucsc::UntitledBehavior
  self.indexer = ::WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
#  validates :title, presence: { message: 'Your work must have a title.' }
  
#  self.human_readable_type = 'Work'

  def solr_doc
    @doc ||= SolrDocument.find(id)
  end

  def save *args

    # This section handles alternate date formates and standardizes them
    ::ScoobySnacks::METADATA_SCHEMA.fields.select{|name, field| field.input == "date"}.each do |field_name, field|
      date_changed = false
      dateUpdate = self.send(field_name.to_sym).map do |date|
        next date unless date.to_s.match?(/\A[12][0-9]{3}[-\/][0-9]{1,2}\z/)
        year, month = date.to_s.split(/[-\/]/)
        date_changed = true
        "#{month}/#{year}"
      end
      self.send("#{field_name.to_s}=".to_sym,dateUpdate) if date_changed
    end

    # This section standardized ambiguous controlled vocab urls
    ::ScoobySnacks::METADATA_SCHEMA.controlled_field_names.each do |field_name|
      attributes = []
      props =  self.send(field_name)
      props = Array(props) if !props.kind_of?(Array)
      props.each do |node|
        next unless node.respond_to?('id')
        if node.id.starts_with?('info:lc')
          attributes << {id: fix_loc_id(node.id) }
          attributes << {id: node.id, _destroy: true}
        elsif node.id.include?("vocab.getty.edu") && node.id.include?("/page/")
          attributes << {id: fix_getty_id(node.id) }
          attributes << {id: node.id, _destroy: true}
        end
      end
      self.send(field_name.to_s+"_attributes=",attributes) unless attributes.empty?
    end

    # This section attempts to ensure that each work has a representative ID
    if representative_id.blank? && members.present?
      representative_id = members.reduce([]){|ids, member| ids + Array(member.representative_id) }.first
    end

    set_thumbnail
    
    # set metadataInheritance based on collection or admin set if applicable
    # (inherit the metadataInheritance property itself)
    if metadataInheritance.blank?
      if (collection = member_of.find{|col| col.class == Collection && col.metadataInheritance.present?})
        metadataInheritance = collection.metadataInheritance 
      elsif admin_set.present? && admin_set.respond_to?(:metadataInheritance) && admin_set.metadataInheritance.present?
        metadataInheritance = admin_set.metadataInheritance 
      end
    end
    
    inherit_metadata
    rv = super *args
    cache_manifest
    return rv
  end

  def set_thumbnail
    # If the thumbnail id is not yet set, set it to something reasonable
    # (if there is something reasonable to set it to)
    if thumbnail_id.blank?
      if representative_id.present?
        self.thumbnail_id = representative_id
      elsif file_sets.present?
        self.thumbnail_id = file_sets.first.id
      elsif members.present?
        self.thumbnail_id = members.map(&:thumbnail_id).compact.first
      end
    end
  end

  def cache_manifest
    @cache_key = "manifest/#{id}"
    ability = User.first.ability
    dummy_request = Class.new{def base_url; CatalogController.root_url; end;}.new
    dummy_presenter = Ucsc::WorkShowPresenter.new(SolrDocument.find(id), ability, dummy_request)
    manifest_builder = ::IIIFManifest::ManifestFactory.new(dummy_presenter)
    Rails.cache.write(@cache_key,manifest_builder.to_h.to_json)
  end

  def fix_loc_id loc_id
    split = loc_id.split('/')
    if (split[-2] == "authorities") or (split[-2] == "vocabulary")
      "http://id.loc.gov/#{split[-2]}/#{split[-1]}"
    else
      "http://id.loc.gov/#{split[-3]}/#{split[-2]}/#{split[-1]}"
    end
  end

  def fix_getty_id getty_id
    getty_id.gsub('/page/','/')
  end

  private

  def inherit_metadata
    # Inheriting here is the default, so skip it only if another valid option is explicitly specified
    return if ["index","display","none","false","no","off"].any?{|valid_option| Array(metadataInheritance).first.to_s.downcase.include?(valid_option)}
    schema = ScoobySnacks::METADATA_SCHEMA
    member_of.each do |parent_doc|
      parent = ActiveFedora::Base.find(parent_doc.id)
      schema.inheritable_fields.each do |field| 
        next unless parent.respond_to?(field.name)
        next if self.send(field.name).present?
        if field.controlled?
          self.send("#{field.name}_attributes=",parent.send(field.name).map{|resource| {id: resource.id}})
        else
          self.send("#{field.name}=",parent.send(field.name))
        end
      end
    end
    member_of_collections.each do |parent_doc|
      parent = ActiveFedora::Base.find(parent_doc.id)
      schema.collection_inheritable_fields.each do |field| 
        next unless parent.respond_to?(field.name)
        next if self.send(field.name).present?
        if field.controlled?
          self.send("#{field.name}_attributes=",parent.send(field.name).map{|resource| {id: resource.id}})
        else
          self.send("#{field.name}=",parent.send(field.name))
        end
      end
    end
  end

end

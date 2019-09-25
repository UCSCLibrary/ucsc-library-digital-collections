# Generated via
#  `rails generate hyrax:work Work`
class Work < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
#  include ::Hyrax::BasicMetadata

  include ::ScoobySnacks::WorkModelBehavior
  include ::Ucsc::UntitledBehavior
  self.indexer = ::WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
#  validates :title, presence: { message: 'Your work must have a title.' }
  
#  self.human_readable_type = 'Work'

  def first_title
    SolrDocument.find(id).titleDisplay.first
  end

  def save *args
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

    if representative_id.blank? && members.present? && members.first.representative_id.present?
      representative_id = members.first.representative_id
    end

    thumbnail_id = representative_id if (thumbnail_id.blank? && representative_id.present?)

    # set metadataInheritance based on collection or admin set if applicable
    if metadataInheritance.blank?
      if (collection = member_of.find{|col| col.class == Collection && col.metadataInheritance.present?})
        metadataInheritance = collection.metadataInheritance 
      elsif admin_set.present? && admin_set.responds_to(:metadataInheritance) && admin_set.metadataInheritance.present?
        metadataInheritance = admin_set.metadataInheritance 
      end
    end

    super *args
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

end

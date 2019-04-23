# Generated via
#  `rails generate hyrax:work Work`
class Work < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
#  include ::Hyrax::BasicMetadata

  include ::ScoobySnacks::WorkModelBehavior
  self.indexer = ::WorkIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  
#  self.human_readable_type = 'Work'

  def save *args
    ::ScoobySnacks::METADATA_SCHEMA.controlled_field_names.each do |field_name|
      attributes = []
      props =  self.send(field_name)
      props = Array(props) if !props.kind_of?(Array)
      props.each do |node|
        next unless node.respond_to?('id')
        next unless node.id.starts_with?('info:lc')
        attributes << {id: fix_loc_id(node.id) }
        attributes << {id: node.id, _destroy: true}
      end
      self.send(field_name.to_s+"_attributes=",attributes) unless attributes.empty?
    end
    super *args
  end

  def fix_loc_id loc_id
    split = loc_id.split('/')
    if split[-2] == "authorities"
      "http://id.loc.gov/authorities/#{split[-1]}"
    else
      "http://id.loc.gov/authorities/#{split[-2]}/#{split[-1]}"
    end
  end

end

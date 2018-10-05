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
  
  self.human_readable_type = 'Work'

  def to_csv_line fields
    line = ''
    fields.map do |field_name| 
      label = false
      if field_name.downcase.include? "label"
        label = true
        field_name = field_name[0..-7]
      end
      values = self.call(field_name)
      values.map do |value|
        value =  label ? WorkIndexer.fetch_remote_label(value.id) : value.id unless value.is_a? String
        '"#{value.gsub("\"","\"\"")}"'
      end.join(',')
    end
    #TODO escape semicolons, quotation marks, commas in field texts
  end

  def self.to_csv work_ids, labels=false
    header = self.csv_header labels
    csv_text = work_ids.reduce(header){|csv, nextwork_id| csv + Work.find(id).to_csv_line(field_names)}
  end

  def self.csv_fields labels=false
    fields = []
    ScoobySnacks::METADATA_SCHEMA.fields.each do |field_name,field|
      fields << field_name
      fields << "#{field_name} Label" if labels && field.controlled?
    end
    return fields
  end

  def save
    controlled_properties.each do |property|
      attributes = []
      props =  self.send(property)
      props = Array(props) if !props.kind_of?(Array)
      props.each do |node|
        next unless node.respond_to?('id')
        next unless node.id.starts_with?('info:lc')
        attributes << {id: fix_loc_id(node.id) }
        attributes << {id: node.id, _destroy: true}
      end
      self.send(property.to_s+"_attributes=",attributes) unless attributes.empty?
    end
    super
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

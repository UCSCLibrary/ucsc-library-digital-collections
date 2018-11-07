class BulkOps::WorkProxy < ApplicationRecord
  self.table_name = "bulk_ops_work_proxys"
  belongs_to :operation, class_name: "BulkOps::Operation"

  attr_accessor :work_type, :visibility, :reference_identifier, :order, :errors

  def interpret_data raw_data, error_file
    metadata = []
    work_type = raw_data["work_type"] || operation.work_type
    visibility = raw_data["visibility"] || operation.visibility
    reference_identifier  = raw_data["reference_identifier"] || operation.reference_identifier
    order = raw_data[:order]
    raw_data.each do |field,value|
      case field.downcase

      when "file", "filename"
        begin
          file = File.open(File.join(operation.BASE_PATH,value))
          uploaded_file = Hyrax::UploadedFile.create(file: file, user: user)
          (metadata[:uploaded_files] ||= []) << uploaded_file.id if !uploaded_file.id.nil?
        rescue Exception => e  
          self.status = "Cannot open file"
          self.save
          return false
        end

      when "collection title","collection"
        if (col = find_collection(value))
          (metadata[:member_of_collection_ids] ||= []) << col.id
        else
          BulkOps::Relationship.create({ work_proxy_id: proxy.id,
                                         identifier_type: 'title',
                                         relationship_type: "collection_title",
                                         object_identifier: value,
                                         status: "incomplete"})
        end

      when "collection id"
        if (col = find_collection(value))
          (metadata[:member_of_collection_ids] ||= []) << col.id
        else
          BulkOps::Relationship.create({ work_proxy_id: proxy.id,
                                         identifier_type: 'id',
                                         relationship_type: "collection_id",
                                         object_identifier: value,
                                         status: "incomplete"})
        end

      when "parent", "child", "next"
        # This field specifies a relationship. 
        # Log this relationship in the database for future processing
        # allow for customized identifier types
        # using the notation "id:a78C2d81"
        if((split = value.split(":")).count == 2)
          reference_identifier = split[0]
          value = split[1]
        end
        BulkOps::Relationship.create({ work_proxy_id: proxy.id,
                                       identifier_type: reference_identifier,
                                       relationship_type: field.downcase,
                                       object_identifier: value,
                                       status: "incomplete"})

      when *(operation.ignored_fields)
      # Ignore this i.e. do nothing
      else
        # this is presumably a normal metadata field

        # if the field name is not a valid metadata element, 
        # check if it is the label of a valid element
        property_name = format_param_name(field)
        if schema["labels"][property_name] && !work_type.camelize.constantize.new.responds_to?(property_name)
          property_name = schema["labels"][property_name] 
        end

        next unless schema["properties"][property_name]

        if schema["properties"][property_name]["controlled"]
          metadata["#{property_name}_attributes"] ||= []
          metadata["#{property_name}_attributes"] << {id: value.strip}
        else
          (metadata[property_name] ||= []) << value.strip if !value.blank?
        end
      end
    end
    
    asets = AdminSet.where({title: "Bulk Ingest Set"})
    unless metadata[:admin_set_id] or asets.empty?
      metadata[:admin_set_id] = asets.first.id
    end
    return metadata
  end
end

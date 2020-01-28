class BulkOps::Parser

  def interpret_controlled_fields 
    
    # The labels array tracks the contents of columns marked as labels,
    # which may require special validation
    labels = {}

    # This hash is populated with relevant data as we loop through the fields
    controlled_data = {}

    @raw_row.each do |field_name, value| 
      next if value.blank?  or field_name.blank?
      field_name = field_name.to_s

      #If our CSV interpreter is feeding us the headers as a line, ignore it.
      next if field_name == value

      #check if they are using the 'field_name.authority' syntax
      authority = nil
      if ((split=field_name.split('.')).count == 2)
        authority = split.last 
        field_name = split.first
      end

      # get the field name, if this column is a metadata field
      field_name_norm = find_field_name(field_name)
      field = schema.get_field(field_name_norm)

      # Ignore anything that isn't a controlled field
      next unless field.present? && field.controlled?

      # Keep track of label fields
      if field_name.downcase.ends_with?("label")
        next if @options["ignore_labels"]  
        labels[field_name_norm] ||= []
        labels[field_name_norm] += BulkOps::Parser.split_values value
        next unless @options["import_labels"]
      end

      # handle multiple values
      value_array = BulkOps::Parser.split_values(value)
      controlled_data[field_name_norm] ||= [] unless value_array.blank?
      value_array.each do |value|
        # Decide of we're dealing with a label or url
        # It's an ID if it's a URL and the name doesn't end in 'label'
        value.strip!
        if value =~ /^#{URI::regexp}$/ and !field_name.downcase.ends_with?("label")
          value_id = value
        #          label = WorkIndexer.fetch_remote_label(value)
        #          error_message =  "cannot fetch remote label for url: #{value}"
        #          report_error( :cannot_retrieve_label , error_message, url: value, row_number: row_number) unless label
        else
          # It's a label, so unescape it and get the id
          value = BulkOps::Parser.unescape_csv(value)
          value_id = get_remote_id(value, property: field_name_norm, authority: authority) || localAuthUrl(field_name_norm, value)
          #          label = value
          report_error(:cannot_retrieve_url, 
                       message: "cannot find or create url for controlled vocabulary label: #{value}", 
                       url: value, 
                       row_number: row_number) unless value_id
        end
        atts = {id: value_id}
        atts[:_destroy] = true if (field_name.downcase.starts_with?("remove") or field_name.downcase.starts_with?("delete"))
        controlled_data[field_name_norm] << atts
      end
    end

    # Actually add all the data
    controlled_data.each do |property_name, data|
      @metadata["#{property_name}_attributes"] ||= [] unless data.blank?
      data.uniq.each do |datum| 
        @metadata["#{property_name}_attributes"].reject!{|val| val[:id] == datum[:id]}
        @metadata["#{property_name}_attributes"] << datum
      end
    end
  end

  

end

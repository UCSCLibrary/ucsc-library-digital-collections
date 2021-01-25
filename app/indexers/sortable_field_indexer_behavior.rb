module SortableFieldIndexerBehavior
  extend ActiveSupport::Concern

  def index_sortable_fields solr_doc
    schema.sortable_fields.each do |field|
      if field.input == "date"
        next unless (date_string = Array(solr_doc[field.solr_name]).first)
        if date_string.to_s.match?(/\A[12][0-9]{3}[-\/][0-9]{1,2}/)
          year, month = date_string.split(/[-\/]/).map(&:to_i)
          date = Date.new(year,month)
        else
          date = Date.parse(date_string)
        end
        solr_doc[field.solr_sort_name] = date.strftime('%FT%TZ')
      else
        solr_doc[field.solr_sort_name] = Array(solr_doc[field.solr_name]).first
      end
    end    
  end
end

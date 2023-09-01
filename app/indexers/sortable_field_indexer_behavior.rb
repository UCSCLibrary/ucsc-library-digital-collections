module SortableFieldIndexerBehavior
  extend ActiveSupport::Concern

  def index_sortable_fields solr_doc
    schema.sortable_fields.each do |field|
      if field.input == "date"
        next unless (date_string = Array(solr_doc[field.solr_name]).first)
        next if date_string.blank?

        # Match YYYY-YYYY and use the first year (ex: 1970-1971 becomes 1970)
        if date_string.to_s.match?(/\A[0-9]{4}[-\/][0-9]{4}\z/)
          date = Date.new(date_string.split(/[-\/]/).first.to_i)
        # Match YYYY-MM or YYYY-M where YYYY starts with 1 or 2 (ex: 2023-01)
        elsif date_string.to_s.match?(/\A[12][0-9]{3}[-\/][0-9]{1,2}\z/)
          year, month = date_string.split(/[-\/]/).map(&:to_i)
          date = Date.new(year,month)
        # Match YYYY that starts with 1 or 2 (ex: 1960)
        elsif date_string.to_s.match?(/\A[12][0-9]{3}\z/)
          date = Date.new(date_string.to_i)
        else
          date = Date.parse(date_string)
        end
        solr_doc[field.solr_sort_name] = date.strftime('%FT%TZ')
      else
        solr_doc[field.solr_sort_name] = Array(solr_doc[field.solr_name]).first
      end
    end
    solr_doc
  end
end

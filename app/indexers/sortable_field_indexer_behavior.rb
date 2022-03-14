# frozen_string_literal: true

module SortableFieldIndexerBehavior
  extend ActiveSupport::Concern

  def index_sortable_fields(solr_doc)
    schema.sortable_fields.each do |field|
      if field.name == 'dateCreated' && solr_doc[schema.get_field('dateCreatedIngest').solr_name].present?
        index_from_ingested_value(field, solr_doc)
      elsif field.input == 'date'
        index_date_input(field, solr_doc)
      else
        solr_doc[field.solr_sort_name] = Array(solr_doc[field.solr_name]).first
      end
    end

    solr_doc
  end

  private

  def index_from_ingested_value(sortable_field, solr_doc)
    ingest_field = schema.get_field('dateCreatedIngest')

    solr_doc[ingest_field.solr_name].each do |value|
      unless valid_ingested_date?(value)
        # TODO: raise error instead?
        Rails.logger.warn(%("#{value}" is not a valid date value for dateCreatedIngest, skipping indexing...))
        next
      end

      sortable_date = if value.match?(/^\d{4}$/)
                        "12-31-#{value}"
                      elsif value.match?(/^\d{4}-\d{2}-\d{2}$/) || value.match?(/^\d{2}-\d{2}-\d{4}$/)
                        value
                      end

      solr_doc[sortable_field.solr_sort_name] << Date.parse(sortable_date).strftime('%FT%TZ')
    end
  end

  # Match only thefollowing date formats:
  # - YYYY
  # - YYYY-MM-DD
  # - MM-DD-YYYY
  def valid_ingested_date?(value)
    value.match?(/^\d{4}$/) ||
      value.match?(/^\d{4}-\d{2}-\d{2}$/) ||
      value.match?(/^\d{2}-\d{2}-\d{4}$/)
  end

  def index_date_input(field, solr_doc)
    next unless (date_string = Array(solr_doc[field.solr_name]).first)
    next if date_string.blank?

    if date_string.to_s.match?(/\A[12][0-9]{3}[-\/][0-9]{1,2}\z/)
      year, month = date_string.split(/[-\/]/).map(&:to_i)
      date = Date.new(year,month)
    elsif date_string.to_s.match?(/\A[12][0-9]{3}\z/)
      date = Date.new(date_string.to_i)
    else
      date = Date.parse(date_string)
    end
    solr_doc[field.solr_sort_name] = date.strftime('%FT%TZ')
  end
end

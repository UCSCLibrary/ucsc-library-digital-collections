class PublishCollectionJob < Hyrax::ApplicationJob
  def perform(collection_id, start=0)
    errors = []
    col = Collection.find(collection_id)
    rows = 100
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("member_of_collection_ids" => collection_id)
    num_works = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 0})["response"]["numFound"]
    until start > num_works
      docs = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: rows, start: start})["response"]["docs"]
      docs.each do  |doc|
        begin
          work = Work.find(doc['id'])
          work.file_sets.each do |file_set|
            file_set.visibility = "open"
            file_set.save
          end
          work.visibility = "open"
          work.save
        rescue
          errors << work.id
        end
      end
      start = start + rows
      Rails.logger.info "publish collection job finished batch #{start/rows} of #{num_rows/rows}"
    end
    col.visibility = "open"
    col.save
    Rails.logger.warn "Found #{errors.count} errors during publication:"
    Rails.logger.warn errors.map(&:to_s).join(',')
  end
end

class PublishCollectionJob < Hyrax::ApplicationJob
  def perform(collection_id, start=0)
    errors = []
    col = Collection.find(collection_id)
    rows = 100
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("member_of_collection_ids" => collection_id, "visibility" => "restricted").gsub("visibility_ssim","visibility_ssi")
    num_works = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 0})["response"]["numFound"]
    until start > num_works
      docs = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: rows, start: start})["response"]["docs"]
      docs.each do  |doc|
        begin
          publish_work doc["id"]
        rescue
          errors << doc['id']
        end
      end
      start = start + rows
      Rails.logger.info "publish collection job finished batch #{start/rows} of #{num_works/rows}"
    end
    publish(col)
    Rails.logger.warn "Found #{errors.count} errors during publication:"
    Rails.logger.warn errors.map(&:to_s).join(',')
  end

  private

  def publish_work id
    work = Work.find(id)
    (work.member_ids - work.file_set_ids).each{|id| publish_work(id)}
    work.file_sets.each{ |file_set| publish(file_set) }
    publish(work)
  end

  def publish object
    object.visibility = "open"
    object.save
  end
end

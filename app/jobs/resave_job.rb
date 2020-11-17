class ResaveJob < Hyrax::ApplicationJob
  def perform(collection_id=nil)
    rows = 100
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("nesting_collection__ancestors" => collection_id )
    num_works = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 0})["response"]["numFound"]
    start = 0
    until start > num_works
      ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: rows, start: start})["response"]["docs"].each do  |doc|
        next if doc["ancestor_collection_titles_ssim"].present?
        ActiveFedora::Base.find(doc['id']).save
      end
      start = start + rows
    end
  end
end

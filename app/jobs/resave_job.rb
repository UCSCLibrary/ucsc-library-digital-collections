class ResaveJob < Hyrax::ApplicationJob
  def perform(work_types=nil)
    rows = 100
    work_types ||= ["Work","Course","Lecture"]
    work_types.each do |work_type|
      query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("has_model" => work_type)
      num_works = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 0})["response"]["numFound"]    
      start = 0
      until start > num_works
        works = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: rows, start: start})["response"]["docs"]
        works.each do  |wrk|
          ActiveFedora::Base.find(wrk['id']).savem
        end
        start = start + rows
      end
    end
  end
end

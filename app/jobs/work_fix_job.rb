class WorkFixJob < Hyrax::ApplicationJob
  def perform
    rows = 100
    start = 0
    errors = []
    corrected = []
    checked = 0
    query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("has_model" => "Work")
    num_works = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 0})["response"]["numFound"]    
    until start > num_works
      works = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: rows, start: start})["response"]["docs"]
      works.each do |wrk|
        checked += 1
        begin
          work = Work.find(wrk["id"])
          next if (work.file_set_ids - work.ordered_member_ids).empty?
          work.file_sets.each do |fs|
            next if work.ordered_member_ids.include? fs.id
            work.ordered_members << fs
          end
          work.save
        rescue
          errors << wrk["id"]
        end
      end
      start = start + rows
    end
    ActionMailer::Base.mail(from: "admin@digitalcollections.library.ucsc.edu",
                              to: "ethenry@ucsc.edu",
                              subject: "results",
                              body: "checked:#{checked}\nerrors:#{errors.count}\ncorrected:#{corrected.count}\n\n\nerrors:\n#{errors.join(',')}\n\ncorrected:\n#{corrected.join(',')}").deliver
  end
end

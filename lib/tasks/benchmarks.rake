desc "run some speed tests for Solr & Fedora"

task worker_benchmark: :environment do

  require 'benchmark'

  timestamp = Time.now.to_i
  fs_query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("has_model" => "FileSet")
  ingest_jobs = Sidekiq::Queue.new("ingest").size
  sample_metadata = {depositor: User.first.email,
                     title: ["Test Benchmark Title"],
                     creator_attributes: [{id: "http://id.loc.gov/authorities/subjects/sh2017004659"}]}
  work = nil
  create = Benchmark.measure { work = Work.create(sample_metadata)}
  edit = Benchmark.measure {work.description = ["a sample description"]; work.save}

  fedora_find = Benchmark.measure { work = Work.find(work.id)}
  solr_find = Benchmark.measure { solr_doc = SolrDocument.find(work.id) }
  num_filesets = 0
  solr_search_general = Benchmark.measure do 
    fs_query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("has_model" => "FileSet")
    num_filesets = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: fs_query, rows: 100})["response"]["numFound"]
  end
  solr_search_specific = Benchmark.measure do 
    fs_query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("has_model" => "FileSet", "description" => "sample")
    ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: fs_query, rows: 100})
  end
  delete = Benchmark.measure { work.destroy }

  report_data = [timestamp,
                 num_filesets, 
                 ingest_jobs] +
                [create,
                 edit,
                 fedora_find,
                 solr_find,
                 solr_search_specific,
                 solr_search_general, 
                 delete].map{ |measurement| measurement.to_s.delete("()\n").split }.reduce(:+)
  report_string = report_data.join(',')+"\n"

  puts "logging benchmark data: #{report_string}"
  File.open("/srv/hyrax/log/benchmarks.log", "a"){|f| f.write(report_string)}

end 

task webapp_benchmark: :environment do

  require 'benchmark'

  timestamp = Time.now.to_i
  fs_query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("has_model" => "FileSet")
  ingest_jobs = Sidekiq::Queue.new("ingest").size
  work = nil
  fedora_find = Benchmark.measure { work = Work.find("bv73c102v")}
  solr_find = Benchmark.measure { solr_doc = SolrDocument.find(work.id) }
  num_filesets = 0
  solr_search_general = Benchmark.measure do 
    num_filesets = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: fs_query, rows: 100})["response"]["numFound"]
  end
  solr_search_specific = Benchmark.measure do 
    specific_query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("has_model" => "FileSet", "description" => "sample")
    ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: specific_query, rows: 100})
  end

  report_data = [timestamp,
                 num_filesets, 
                 ingest_jobs] +
                [fedora_find,
                 solr_find,
                 solr_search_specific,
                 solr_search_general].map{ |measurement| measurement.to_s.delete("()\n").split }.reduce(:+)
  report_string = report_data.join(',') + "\n"

  puts "logging benchmark data: #{report_string}"
  File.open("/srv/hyrax/log/benchmarks.log", "a"){|f| f.write(report_string)}

end 

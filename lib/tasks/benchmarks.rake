desc "run some speed benchmarks for Solr & Fedora"

task benchmark: :environment do

  require 'benchmark'

  sample_metadata = {depositor: User.first.email,
                     title: ["Test Benchmark Title"],
                     creator_attributes: [{id: "http://id.loc.gov/authorities/subjects/sh2017004659"}]}

  Benchmark.bm do |benchmark|
    benchmark.report('create work') do
      work = Work.create(sample_metadata)
    end

    benchmark.report('edit work') do
      work.description = ["a sample description"]
      work.save
    end
    
    benchmark.report('load existing work (fedora)') do
      work = Work.find(work.id)
    end

    benchmark.report('load existing work (solr)') do
      solr_doc = SolrDocument.find(work.id)
    end

    benchmark.report('delete work') do
      work.destroy
    end
  end
end

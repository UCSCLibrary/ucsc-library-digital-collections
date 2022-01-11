class ReindexJob < Hyrax::ApplicationJob

  def id_list_file
    unless File.exists?(logname('list'))
      File.open(logname('list'),'w') do |f|
        start = 0
        rows = 100
        query = ActiveFedora::SolrQueryBuilder.construct_query_for_rel("has_model" => "Work", "visibility" => "open").gsub("visibility_ssim","visibility_ssi")
        num_works = ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: 0})["response"]["numFound"]
        until start > num_works
          ActiveFedora::SolrService.instance.conn.get(ActiveFedora::SolrService.select_path, params: { fq: query, rows: rows, start: start})["response"]["docs"].each do |doc|
            f.puts doc["id"]
          end
          start += rows
        end
      end
    end
    return File.open(logname('list'),'r')
  end

  def log_file
    @log_file ||= File.open(logname(),'a')
  end

  def last_file
    File.open(logname('last'),'a')
  end

  def error_file
    @error_file ||= File.open(logname("errors"),'a')
  end

  def logname(log_id="log")
    File.join(Rails.root,"log","reindex_#{log_id}_#{@job_name}.txt")
  end

  def log(line)
    log_file.puts(Time.now.strftime("%m/%d/%Y %I:%M %p: ")+line)
  end

  def report_last(i)
    File.open(logname('last'),'w'){|f| f.puts(i)}
  end

  def last_complete
     return 0 unless File.exists?(logname('last'))
#    return 0 unless (File.exists?(logname('last')) && !File.zero?(logname('last')))
    (File.open(logname('last'), &:gets).strip || 0).to_i
  end

  def report_error(error, id)
    error_file.puts("#{Time.now.strftime("%m/%d/%Y %I:%M %p")} - id##{id} : #{error.message}")
  end
  
  def perform(job_name="default",start=nil)
    begin
      @start = last_complete
      @start = start unless start.nil?
      @start = 0 if @start.nil?
      rows = 100
      @job_name = job_name
      i=start
      id_list = id_list_file
      id_list.seek(i)
      while(id = id_list.readline.strip)
        begin
          ActiveFedora::Base.find(id).save
        rescue StandardError => e
          report_error(e,id)
        end
        log("completed work #{i}")
        puts("\n\ncompleted work #{i}\n\n")
        i += 1
      end
#    rescue StandardError => e
#      report_error(e,'NO ID')
    ensure
      report_last(i)
      log_file.close unless log_file.nil?
      error_file.close unless error_file.nil?
    end
  end
  
end

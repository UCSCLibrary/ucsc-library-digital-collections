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
      while(id = id_list.readline)
        begin
          ActiveFedora::Base.find(doc['id']).save
        rescue StandardError => e
          report_error(e,doc['id'])
        end
        log("completed work #{i} of #{num_works}")
        puts("\n\ncompleted work #{i} of #{num_works}\n\n")
        i += 1
      end
    rescue StandardError => e
      report_error(e,'NO ID')
    ensure
      report_last(i)
      log_file.close unless log_file.nil?
      error_file.close unless error_file.nil?
    end
  end


2.7.2 :318 >   def perform(job_name="default",start=nil)
2.7.2 :319 >     begin
2.7.2 :320 >       @start = last_complete
2.7.2 :321 >       @start = start unless start.nil?
2.7.2 :322 >       @start = 0 if @start.nil?
2.7.2 :323 >       rows = 100
2.7.2 :324 >       @job_name = job_name
2.7.2 :325 >       i=@start; puts i
2.7.2 :326 >       id_list = id_list_file
2.7.2 :327 >       id_list.seek(i)
2.7.2 :328 >       while(id = id_list.readline.strip)
2.7.2 :329 >         puts id; begin
2.7.2 :330 >           ActiveFedora::Base.find(id).save
2.7.2 :331 >         rescue StandardError => e
2.7.2 :332 >           report_error(e,id)
2.7.2 :333 >         end
2.7.2 :334 >         log("completed work #{i}")
2.7.2 :335 >         puts("\n\ncompleted work #{i}\n\n")
2.7.2 :336 >         i += 1
2.7.2 :337 >       end
2.7.2 :338 > #    rescue StandardError => e
2.7.2 :339 > #      report_error(e,'NO ID')
2.7.2 :340 >     ensure
2.7.2 :341 >       report_last(i)
2.7.2 :342 >       log_file.close unless log_file.nil?
2.7.2 :343 >       error_file.close unless error_file.nil?
2.7.2 :344 >     end
2.7.2 :345 >   end

  
end

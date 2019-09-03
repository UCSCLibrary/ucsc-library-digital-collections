class AttachFilesToWorkJob
  after_perform do |job|
    wrk = job.arguments.first
    wrk.save
  end
end

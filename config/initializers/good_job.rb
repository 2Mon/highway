Rails.application.configure do
  config.active_job.queue_adapter = :good_job
  config.good_job.preserve_job_records = true
  config.good_job.cleanup_preserved_jobs_before_seconds_ago = 60 * 60 * 24 * 7
  config.good_job.cleanup_interval_jobs = 1000
  config.good_job.cleanup_interval_seconds = 3600

  config.good_job.execution_mode = :async
end

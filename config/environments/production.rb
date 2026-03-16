require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  config.log_level = :info
  config.log_tags = [:request_id]
  config.cache_store = :memory_store
  config.active_job.queue_adapter = :async
  config.active_storage.service = :local
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false

  config.force_ssl = false
  config.require_master_key = false
end

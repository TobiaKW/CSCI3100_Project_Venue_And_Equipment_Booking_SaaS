require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key, or an environment
  # key such as config/credentials/production.key. This key is used to decrypt credentials (and other encrypted files).
  # config.require_master_key = true

  # Serve static files (Heroku has no separate web server)
  config.public_file_server.enabled = true

  # Compress CSS using a preprocessor.
  # config.assets.css_compressor = :sass

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  # Can be used together with config.force_ssl for Strict-Transport-Security and secure cookies.
  # config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Skip http-to-https redirect for the default health check endpoint.
  config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT by default
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # "info" includes generic and useful information about system operation, but avoids logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII). If you
  # want to log everything, set the level to "debug".
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # ---- Action Mailer (SendGrid SMTP) ----
  # Render env: SMTP_USERNAME=apikey, SMTP_PASSWORD=<SendGrid API key>, MAIL_FROM=<verified sender>
  # Optional: SMTP_PORT=465 if 587 times out; SMTP_OPEN_TIMEOUT / SMTP_READ_TIMEOUT
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_options = { from: ENV.fetch("MAIL_FROM", "no-reply@example.com") }

  smtp_port = Integer(ENV.fetch("SMTP_PORT", "587"))
  use_implicit_ssl = smtp_port == 465

  smtp_settings = {
    address: ENV.fetch("SMTP_ADDRESS", "smtp.sendgrid.net"),
    port: smtp_port,
    domain: ENV.fetch("SMTP_DOMAIN", ENV.fetch("SENDGRID_DOMAIN", "localhost")),
    user_name: ENV.fetch("SMTP_USERNAME", ENV.fetch("SENDGRID_USERNAME", nil)),
    password: ENV.fetch("SMTP_PASSWORD", ENV.fetch("SENDGRID_PASSWORD", nil)),
    authentication: :plain,
    open_timeout: Integer(ENV.fetch("SMTP_OPEN_TIMEOUT", "60")),
    read_timeout: Integer(ENV.fetch("SMTP_READ_TIMEOUT", "120"))
  }

  if use_implicit_ssl
    smtp_settings[:enable_starttls_auto] = false
    smtp_settings[:tls] = true
    smtp_settings[:ssl] = true
  else
    smtp_settings[:enable_starttls_auto] = true
  end

  config.action_mailer.smtp_settings = smtp_settings

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [ :id ]

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end

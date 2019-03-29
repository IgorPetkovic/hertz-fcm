# frozen_string_literal: true

Hertz::Fcm.configure do |config|
  # Your Firebase Cloud Messaging configuration.
  config.project_id = 'project_id'
  config.google_private_key = 'private_key'
  config.google_client_email = 'email'
  config.deletion_job_class_name = 'DeleteTokenJob'
end

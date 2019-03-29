# frozen_string_literal: true

require 'firebase_cloud_messenger'
require 'hertz'

require 'hertz/fcm/engine'
require 'hertz/fcm/version'

module Hertz
  module Fcm
    mattr_accessor :project_id, :google_private_key, :google_client_email,
                   :deletion_job_class_name

    class << self
      def configure
        yield(self)

        FirebaseCloudMessenger.project_id = project_id
        ENV['GOOGLE_PRIVATE_KEY'] = google_private_key
        ENV['GOOGLE_CLIENT_EMAIL'] = google_client_email
      end

      def deliver_notification(notification)
        Hertz::Fcm::NotificationDeliveryJob.perform_later(notification)
      end
    end
  end
end

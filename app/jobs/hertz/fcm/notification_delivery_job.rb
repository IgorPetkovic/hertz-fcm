# frozen_string_literal: true

module Hertz
  module Fcm
    class NotificationDeliveryJob < ActiveJob::Base
      queue_as :default

      def perform(notification)
        return if notification.receiver.registration_ids.blank?
        return if notification.delivered_with?(:fcm)

        fcm_client.send(
          notification.receiver.registration_ids,
          notification.options
        )

        notification.mark_delivered_with(:fcm)
      end

      private

      def fcm_client
        @fcm_client ||= ::FCM.new(
          Hertz::Fcm.server_key
        )
      end
    end
  end
end

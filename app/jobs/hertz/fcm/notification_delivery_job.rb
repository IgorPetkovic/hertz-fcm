# frozen_string_literal: true

module Hertz
  module Fcm
    class NotificationDeliveryJob < ActiveJob::Base
      queue_as :default

      def perform(notification)
        PushNotificationSender.new(notification).run
      end
    end
  end
end

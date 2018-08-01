# frozen_string_literal: true

require 'fcm'
require 'hertz'

require 'hertz/fcm/engine'
require 'hertz/fcm/version'

module Hertz
  module Fcm
    mattr_accessor :server_key

    class << self
      def configure
        yield(self)
      end

      def deliver_notification(notification)
        Hertz::Fcm::NotificationDeliveryJob.perform_later(notification)
      end
    end
  end
end

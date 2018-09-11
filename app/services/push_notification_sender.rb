# frozen_string_literal: true

class PushNotificationSender
  attr_reader :notification

  REQUIRED_KEYS = %i[title body].freeze

  def initialize(notification)
    @notification = notification
  end

  def run
    return if notification.receiver.device_ids.blank?
    return if notification.delivered_with?(:fcm)
    return unless REQUIRED_KEYS.all? { |key| notification.respond_to?(key) }

    fcm_client.send(
      notification.receiver.device_ids,
      options
    )

    notification.mark_delivered_with(:fcm)
  end

  private

  def fcm_client
    @fcm_client ||= ::FCM.new(
      Hertz::Fcm.server_key
    )
  end

  def options
    {
      notification: REQUIRED_KEYS.map { |key| [key, notification.send(key)] }.to_h
    }
  end
end

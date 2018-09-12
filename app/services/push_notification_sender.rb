# frozen_string_literal: true

class PushNotificationSender
  attr_reader :notification

  REQUIRED_KEYS = %i[title body].freeze
  OPTIONAL_KEYS = %i[click_action sound android_channel_id icon].freeze

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

  def keys
    REQUIRED_KEYS + OPTIONAL_KEYS.select { |key| notification.respond_to?(key) }
  end

  def options
    {
      notification: keys.map { |key| [key, notification.send(key)] }.to_h,
      data: notification.send(:data)
    }
  end
end

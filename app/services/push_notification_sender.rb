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

    notification.receiver.device_ids.each do |device_id|
      fcm_client.send(message: message(device_id))
    rescue FirebaseCloudMessenger::Error
      job_class = Hertz::Fcm.deletion_job_class_name.safe_constantize
      job_class.perform_later(device_id)
    end

    notification.mark_delivered_with(:fcm)
  end

  private

  def fcm_client
    @fcm_client ||= FirebaseCloudMessenger
  end

  def keys
    REQUIRED_KEYS + OPTIONAL_KEYS.select { |key| notification.respond_to?(key) }
  end

  def message(token)
    {
      data: keys.map { |key| [key, notification.send(key)] }.to_h
                .merge!(notification.send(:data)),
      apns: {
        payload: {
          aps: aps
        }
      },
      token: token
    }
  end

  def aps
    if notification.respond_to?(:silent?) && notification.send(:silent?)
      return {
        category: notification.send(:click_action),
        'content-available' => 1
      }
    end

    {
      alert: {
        title: notification.send(:title),
        body: notification.send(:body)
      },
      sound: notification.send(:sound),
      category: notification.send(:click_action)
    }
  end
end

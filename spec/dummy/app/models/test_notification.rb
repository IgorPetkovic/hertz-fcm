# frozen_string_literal: true

class TestNotification < Hertz::Notification
  deliver_by :fcm

  def options
    {
      notification: {
        title: 'Test',
        body: 'Test'
      }
    }
  end
end

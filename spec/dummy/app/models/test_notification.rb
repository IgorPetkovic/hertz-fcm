# frozen_string_literal: true

class TestNotification < Hertz::Notification
  deliver_by :fcm

  def body
    'Test'
  end

  def title
    'Test'
  end
end

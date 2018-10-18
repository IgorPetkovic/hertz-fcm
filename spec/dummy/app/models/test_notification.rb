# frozen_string_literal: true

class TestNotification < Hertz::Notification
  deliver_by :fcm

  def body
    'Test'
  end

  def title
    'Test'
  end

  def click_action
    'action'
  end

  def sound
    'sound'
  end

  def data
    {}
  end
end

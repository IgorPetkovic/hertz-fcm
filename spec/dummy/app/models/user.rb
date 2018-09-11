# frozen_string_literal: true

class User < ApplicationRecord
  include Hertz::Notifiable

  has_many :mobile_devices

  def device_ids
    mobile_devices.pluck(:token)
  end
end

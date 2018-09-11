# frozen_string_literal: true

FactoryBot.define do
  factory :mobile_device do
    token { SecureRandom.hex }
  end
end

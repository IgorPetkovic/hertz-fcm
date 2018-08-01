# frozen_string_literal: true

FactoryBot.define do
  factory :registration_id do
    token { SecureRandom.hex }
  end
end

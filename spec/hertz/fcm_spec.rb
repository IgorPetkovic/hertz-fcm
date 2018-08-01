# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hertz::Fcm do
  it 'has a version number' do
    expect(Hertz::Fcm::VERSION).not_to be nil
  end

  describe '.configure' do
    let(:server_key) { 'my_server_key' }

    it 'changes the configuration options' do
      expect do
        described_class.configure do |config|
          config.server_key = server_key
        end
      end.to change(described_class, :server_key).to(server_key)
    end
  end

  describe '.deliver_notification' do
    let(:notification) { build_stubbed(:test_notification) }

    it 'schedules the delivery' do
      expect do
        described_class.deliver_notification(notification)
      end.to enqueue_a(described_class::NotificationDeliveryJob)
        .with(global_id(notification))
    end
  end
end

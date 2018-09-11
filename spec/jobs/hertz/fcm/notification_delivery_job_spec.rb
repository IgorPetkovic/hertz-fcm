# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hertz::Fcm::NotificationDeliveryJob do
  subject { described_class.new }

  let(:fcm_client) { instance_double('FCM') }
  let(:user) { build_stubbed(:user) }
  let(:mobile_device) { build_stubbed(:mobile_device, user: user) }
  let(:mobile_devices) { [mobile_device] }
  let(:device_ids) { [mobile_device.token] }
  let(:notification) { build_stubbed(:test_notification) }

  before do
    allow(::FCM).to receive(:new)
      .and_return(fcm_client)

    allow(fcm_client).to receive(:send)

    allow(notification).to receive(:receiver)
      .and_return(user)

    allow(notification).to receive(:delivered_with?)
      .with(:fcm)
      .and_return(false)

    allow(notification).to receive(:mark_delivered_with)
      .with(:fcm)

    allow(user).to receive(:mobile_devices)
      .and_return(mobile_devices)
  end

  it 'delivers the notification via Firebase Cloud Messaging' do
    subject.perform(notification)

    expect(fcm_client).to have_received(:send)
      .with(device_ids, a_kind_of(Hash))
  end

  it 'marks the notification as delivered through fcm' do
    subject.perform(notification)

    expect(notification).to have_received(:mark_delivered_with)
      .with(:fcm)
      .once
  end

  context 'when the receiver does not have mobile devices' do
    before do
      allow(user).to receive(:mobile_devices)
        .and_return(MobileDevice.none)
    end

    it 'does not deliver the notification' do
      subject.perform(notification)
      expect(fcm_client).not_to have_received(:send)
    end
  end

  context 'when the notification was already delivered through fcm' do
    before do
      allow(notification).to receive(:delivered_with?)
        .with(:fcm)
        .and_return(true)
    end

    it 'does not deliver the notification' do
      subject.perform(notification)
      expect(fcm_client).not_to have_received(:send)
    end
  end
end

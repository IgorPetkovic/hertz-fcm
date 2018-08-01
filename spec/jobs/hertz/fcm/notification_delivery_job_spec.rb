# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hertz::Fcm::NotificationDeliveryJob do
  subject { described_class.new }

  let(:fcm_client) { instance_double('FCM') }
  let(:user) { build_stubbed(:user) }
  let(:registration_id) { build_stubbed(:registration_id, user: user) }
  let(:registration_ids) { [registration_id] }
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

    allow(user).to receive(:registration_ids)
      .and_return(registration_ids)
  end

  it 'delivers the notification via Firebase Cloud Messaging' do
    subject.perform(notification)

    expect(fcm_client).to have_received(:send)
      .with(registration_ids, notification.options)
  end

  it 'marks the notification as delivered through fcm' do
    subject.perform(notification)

    expect(notification).to have_received(:mark_delivered_with)
      .with(:fcm)
      .once
  end

  context 'when the receiver does not have registration ids' do
    before do
      allow(user).to receive(:registration_ids)
        .and_return(nil)
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

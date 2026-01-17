# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client'

RSpec.describe 'New CDEK API Entities' do
  describe CDEKApiClient::Entities::Barcode do
    it 'can be initialized with required parameters' do
      barcode = described_class.new(orders: [{ order_uuid: 'test-uuid' }])
      expect(barcode).to be_a(described_class)
    end

    it 'can be created with orders UUID helper' do
      barcode = described_class.with_orders_uuid('test-uuid')
      expect(barcode.orders.first[:order_uuid]).to eq('test-uuid')
    end

    it 'can be created with CDEK numbers helper' do
      barcode = described_class.with_cdek_numbers('123456789')
      expect(barcode.orders.first[:cdek_number]).to eq('123456789')
    end
  end

  describe CDEKApiClient::Entities::Invoice do
    it 'can be initialized with required parameters' do
      invoice = described_class.new(orders: [{ order_uuid: 'test-uuid' }])
      expect(invoice).to be_a(described_class)
    end

    it 'can be created with orders UUID helper' do
      invoice = described_class.with_orders_uuid('test-uuid')
      expect(invoice.orders.first[:order_uuid]).to eq('test-uuid')
    end

    it 'can be created with CDEK numbers helper' do
      invoice = described_class.with_cdek_numbers('123456789')
      expect(invoice.orders.first[:cdek_number]).to eq('123456789')
    end
  end

  describe CDEKApiClient::Entities::Agreement do
    it 'can be initialized with required parameters' do
      agreement = described_class.new(
        cdek_number: '123456789',
        date: '2024-01-17',
        time_from: '10:00',
        time_to: '18:00',
        comment: 'Test comment'
      )
      expect(agreement).to be_a(described_class)
    end
  end

  describe CDEKApiClient::Entities::Intakes do
    it 'can be initialized with required parameters' do
      intakes = described_class.new(
        cdek_number: '123456789',
        intake_date: '2024-01-17',
        intake_time_from: '10:00',
        intake_time_to: '18:00',
        lunch_time_from: '13:00',
        lunch_time_to: '14:00',
        name: 'Test cargo',
        need_call: true,
        comment: 'Test comment',
        sender: { name: 'Test Sender', phones: [{ number: '+79001234567' }] },
        from_location: { code: 44, address: 'Test Address' },
        weight: 100,
        length: 10,
        width: 10,
        height: 10
      )
      expect(intakes).to be_a(described_class)
    end
  end

  describe CDEKApiClient::Entities::Check do
    it 'can be initialized with optional parameters' do
      check = described_class.new
      expect(check).to be_a(described_class)
    end

    it 'can be initialized with cdek_number' do
      check = described_class.new(cdek_number: '123456789')
      expect(check.cdek_number).to eq('123456789')
    end

    it 'can be initialized with date' do
      check = described_class.new(date: '2024-01-17')
      expect(check.date).to eq('2024-01-17')
    end

    it 'provides query params' do
      check = described_class.new(cdek_number: '123456789', date: '2024-01-17')
      expect(check.to_query_params).to eq({ cdek_number: '123456789', date: '2024-01-17' })
    end
  end
end

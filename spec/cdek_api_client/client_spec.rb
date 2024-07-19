# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client'
require 'faker'

RSpec.describe CDEKApiClient::Client, :vcr do
  let(:client_id) { 'wqGwiQx0gg8mLtiEKsUinjVSICCjtTEP' }
  let(:client_secret) { 'RmAmgvSgSl1yirlz9QupbzOJVqhCxcP5' }
  let(:client) { described_class.new(client_id, client_secret) }

  let(:webhook_data) do
    CDEKApiClient::Entities::Webhook.new(
      url: 'https://yourapp.com/webhooks/cdek',
      type: 'ORDER_STATUS',
      event_types: %w[ORDER_STATUS DELIVERY_STATUS]
    )
  end

  let(:recipient) do
    CDEKApiClient::Entities::Recipient.new(
      name: Faker::Name.name,
      phones: [{ number: Faker::PhoneNumber.cell_phone_in_e164 }],
      email: Faker::Internet.email
    )
  end

  let(:sender) do
    CDEKApiClient::Entities::Sender.new(
      name: Faker::Name.name,
      phones: [{ number: Faker::PhoneNumber.cell_phone_in_e164 }],
      email: Faker::Internet.email
    )
  end

  let(:item) do
    CDEKApiClient::Entities::Item.new(
      name: Faker::Commerce.product_name,
      ware_key: Faker::Alphanumeric.alphanumeric(number: 5),
      payment: CDEKApiClient::Entities::Payment.new(value: Faker::Commerce.price(range: 10..1000).to_i,
                                                    currency: 'RUB'),
      cost: Faker::Commerce.price(range: 10..1000).to_i,
      weight: Faker::Number.between(from: 100, to: 5000),
      amount: Faker::Number.between(from: 1, to: 10)
    )
  end

  let(:package) do
    CDEKApiClient::Entities::Package.new(
      number: Faker::Alphanumeric.alphanumeric(number: 10),
      weight: Faker::Number.between(from: 100, to: 5000),
      length: Faker::Number.between(from: 10, to: 100),
      width: Faker::Number.between(from: 10, to: 100),
      height: Faker::Number.between(from: 10, to: 100),
      items: [item],
      comment: Faker::Lorem.sentence
    )
  end

  let(:order_data) do
    CDEKApiClient::Entities::OrderData.new(
      type: 1,
      number: Faker::Alphanumeric.alphanumeric(number: 10),
      tariff_code: Faker::Number.between(from: 1, to: 10),
      from_location: CDEKApiClient::Entities::Location.new(code: 16_584, city: Faker::Address.city,
                                                           address: Faker::Address.full_address),
      to_location: CDEKApiClient::Entities::Location.new(code: 16_584, city: Faker::Address.city,
                                                         address: Faker::Address.full_address),
      recipient:,
      sender:,
      packages: [package],
      comment: Faker::Lorem.sentence,
      services: [
        CDEKApiClient::Entities::Service.new(code: 'INSURANCE', price: Faker::Commerce.price(range: 10..1000).to_i,
                                             name: Faker::Commerce.product_name)
      ]
    )
  end

  describe '#create_order' do
    it 'creates an order successfully' do
      VCR.use_cassette('create_order') do
        response = client.order.create(order_data)
        expect(response['requests'].first['state']).to eq('ACCEPTED')
      end
    end
  end

  describe '#track_order' do
    let(:order_uuid) { order_response['entity']['uuid'] }

    let(:order_response) do
      VCR.use_cassette('create_order') do
        client.order.create(order_data)
      end
    end

    it 'tracks an order successfully' do
      VCR.use_cassette('track_order') do
        response = client.order.track(order_uuid)
        expect(response['entity']).to include('uuid' => order_uuid)
      end
    end
  end

  describe '#calculate_tariff' do
    let(:tariff_data) do
      CDEKApiClient::Entities::TariffData.new(
        type: 1,
        currency: 'RUB',
        tariff_code: 139,
        from_location: CDEKApiClient::Entities::Location.new(code: 16_584, city: Faker::Address.city,
                                                             address: Faker::Address.full_address),
        to_location: CDEKApiClient::Entities::Location.new(code: 16_584, city: Faker::Address.city,
                                                           address: Faker::Address.full_address),
        packages: [package]
      )
    end

    it 'calculates the tariff successfully' do
      VCR.use_cassette('calculate_tariff') do
        response = client.tariff.calculate(tariff_data)
        expect(response).to include('total_sum')
      end
    end
  end

  describe '#register_webhook' do
    it 'registers a webhook successfully' do
      VCR.use_cassette('register_webhook') do
        response = client.webhook.register(webhook_data)
        expect(response['entity']).to include('uuid')
      end
    end
  end

  describe '#get_webhooks' do
    it 'retrieves webhooks successfully' do
      VCR.use_cassette('get_webhooks') do
        response = client.webhook.list
        expect(response).to be_an(Array)
      end
    end
  end

  describe '#delete_webhook' do
    let(:webhook_id) do
      response = VCR.use_cassette('register_webhook') do
        client.webhook.register(webhook_data)
      end

      response['entity']['uuid']
    end

    it 'deletes a webhook successfully' do
      VCR.use_cassette('delete_webhook') do
        client.webhook.delete(webhook_id)
      end
    end
  end
end

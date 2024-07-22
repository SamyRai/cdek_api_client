# spec/cdek_api_client/models/order_spec.rb
# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client'
require 'faker'

RSpec.describe CDEKApiClient::Order, :vcr do
  let(:client_id) { 'wqGwiQx0gg8mLtiEKsUinjVSICCjtTEP' }
  let(:client_secret) { 'RmAmgvSgSl1yirlz9QupbzOJVqhCxcP5' }
  let(:client) { CDEKApiClient::Client.new(client_id, client_secret) }
  let(:order) { client.order }

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

  describe '#create' do
    it 'creates an order successfully' do
      VCR.use_cassette('create_order') do
        response = order.create(order_data)
        expect(response).not_to include('error')
        expect(response['requests'].first['state']).to eq('ACCEPTED')
      end
    end
  end

  describe '#track' do
    let(:order_uuid) do
      response = VCR.use_cassette('create_order') do
        order.create(order_data)
      end
      response['entity']['uuid']
    end

    it 'tracks an order successfully' do
      VCR.use_cassette('track_order') do
        response = order.track(order_uuid)
        expect(response).not_to include('error')
        expect(response['entity']).to include('uuid' => order_uuid)
      end
    end
  end
end

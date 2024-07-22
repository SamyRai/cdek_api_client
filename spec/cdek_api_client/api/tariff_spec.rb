# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client'
require 'faker'

RSpec.describe CDEKApiClient::Tariff, :vcr do
  let(:client_id) { 'wqGwiQx0gg8mLtiEKsUinjVSICCjtTEP' }
  let(:client_secret) { 'RmAmgvSgSl1yirlz9QupbzOJVqhCxcP5' }
  let(:client) { CDEKApiClient::Client.new(client_id, client_secret) }
  let(:tariff) { client.tariff }

  let(:tariff_data) do
    CDEKApiClient::Entities::TariffData.new(
      type: 1,
      currency: 'RUB',
      tariff_code: 139,
      from_location: CDEKApiClient::Entities::Location.new(code: 16_584, city: Faker::Address.city,
                                                           address: Faker::Address.full_address),
      to_location: CDEKApiClient::Entities::Location.new(code: 16_584, city: Faker::Address.city,
                                                         address: Faker::Address.full_address),
      packages: [
        CDEKApiClient::Entities::Package.new(
          number: Faker::Alphanumeric.alphanumeric(number: 10),
          weight: Faker::Number.between(from: 100, to: 5000),
          length: Faker::Number.between(from: 10, to: 100),
          width: Faker::Number.between(from: 10, to: 100),
          height: Faker::Number.between(from: 10, to: 100),
          items: [
            CDEKApiClient::Entities::Item.new(
              name: Faker::Commerce.product_name,
              ware_key: Faker::Alphanumeric.alphanumeric(number: 5),
              payment: CDEKApiClient::Entities::Payment.new(value: Faker::Commerce.price(range: 10..1000).to_i,
                                                            currency: 'RUB'),
              cost: Faker::Commerce.price(range: 10..1000).to_i,
              weight: Faker::Number.between(from: 100, to: 5000),
              amount: Faker::Number.between(from: 1, to: 10)
            )
          ],
          comment: Faker::Lorem.sentence
        )
      ]
    )
  end

  describe '#calculate' do
    it 'calculates the tariff successfully' do
      VCR.use_cassette('calculate_tariff') do
        response = tariff.calculate(tariff_data)
        expect(response).not_to include('error')
        raise "Unexpected response format: #{response.inspect}" unless response['total_sum']

        expect(response).to include('total_sum')
      end
    end
  end
end

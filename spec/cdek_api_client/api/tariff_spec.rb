# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client'
require 'faker'

RSpec.describe CDEKApiClient::API::Tariff, :vcr do
  include ClientHelper

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
    subject(:response) { tariff.calculate(tariff_data) }

    it 'does not include error' do
      VCR.use_cassette('calculate_tariff') do
        expect(response).not_to include('error')
      end
    end

    it 'calculates the total_sum' do
      VCR.use_cassette('calculate_tariff') do
        raise "Unexpected response format: #{response.inspect}" unless response['total_sum']

        expect(response).to include('total_sum')
      end
    end
  end
end

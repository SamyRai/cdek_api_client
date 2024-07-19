# frozen_string_literal: true

require_relative 'validatable'
require_relative 'currency_mapper'

module CDEKApiClient
  module Entities
    class TariffData
      include Validatable

      attr_accessor :type, :currency, :from_location, :to_location, :packages, :tariff_code

      validates :type, type: :integer, presence: true
      validates :currency, type: :integer, presence: true
      validates :tariff_code, type: :integer, presence: true
      validates :from_location, type: :object, presence: true
      validates :to_location, type: :object, presence: true
      validates :packages, type: :array, presence: true, items: [Package]

      def initialize(type:, currency:, from_location:, to_location:, packages:, tariff_code:)
        @type = type
        @currency = CurrencyMapper.to_code(currency)
        @from_location = from_location
        @to_location = to_location
        @packages = packages
        @tariff_code = tariff_code
        validate!
      end

      def to_json(*_args)
        {
          type: @type,
          currency: @currency,
          from_location: @from_location,
          to_location: @to_location,
          packages: @packages,
          tariff_code: @tariff_code
        }.to_json
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'validatable'
require_relative 'currency_mapper'

module CDEKApiClient
  module Entities
    # Represents the data required to calculate a tariff in the CDEK API.
    # Each tariff data includes attributes such as type, currency, from_location, to_location, packages, and tariff_code.
    class TariffData
      include Validatable

      attr_accessor :type, :currency, :from_location, :to_location, :packages, :tariff_code

      validates :type, type: :integer, presence: true
      validates :currency, type: :integer, presence: true
      validates :tariff_code, type: :integer, presence: true
      validates :from_location, type: :object, presence: true
      validates :to_location, type: :object, presence: true
      validates :packages, type: :array, presence: true, items: [Package]

      # Initializes a new TariffData object.
      #
      # @param type [Integer] the type of the tariff.
      # @param currency [String] the currency code of the tariff.
      # @param from_location [Location] the location from which the tariff calculation starts.
      # @param to_location [Location] the destination location for the tariff calculation.
      # @param packages [Array<Package>] the list of packages included in the tariff calculation.
      # @param tariff_code [Integer] the tariff code.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(type:, currency:, from_location:, to_location:, packages:, tariff_code:)
        @type = type
        @currency = CurrencyMapper.to_code(currency)
        @from_location = from_location
        @to_location = to_location
        @packages = packages
        @tariff_code = tariff_code
        validate!
      end

      # Converts the TariffData object to a JSON representation.
      #
      # @return [String] the JSON representation of the TariffData.
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

# frozen_string_literal: true

require_relative 'validatable'
require_relative 'currency_mapper'

module CDEKApiClient
  module Entities
    # Represents a payment entity in the CDEK API.
    # Each payment includes attributes such as value and currency.
    class Payment
      include Validatable

      attr_accessor :value, :currency

      validates :value, type: :integer, presence: true, positive: true
      validates :currency, type: :integer, presence: true

      # Initializes a new Payment object.
      #
      # @param value [Integer] the payment value.
      # @param currency [String] the currency code for the payment.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(value:, currency:)
        @value = value
        @currency = CurrencyMapper.to_code(currency)
        validate!
      end

      # Converts the Payment object to a JSON representation.
      #
      # @return [String] the JSON representation of the Payment.
      def to_json(*_args)
        {
          value: @value,
          currency: @currency
        }.to_json
      end
    end
  end
end

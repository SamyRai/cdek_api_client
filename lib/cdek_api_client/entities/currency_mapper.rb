# frozen_string_literal: true

module CDEKApiClient
  module Entities
    # CurrencyMapper is a utility module that maps currency codes to their respective integer representations.
    module CurrencyMapper
      CURRENCY_CODES = {
        'RUB' => 1,
        'KZT' => 2,
        'USD' => 3,
        'EUR' => 4,
        'GBP' => 5,
        'CNY' => 6,
        'BYR' => 7,
        'UAH' => 8,
        'KGS' => 9,
        'AMD' => 10,
        'TRY' => 11,
        'THB' => 12,
        'KRW' => 13,
        'AED' => 14,
        'UZS' => 15,
        'MNT' => 16,
        'PLN' => 17,
        'AZN' => 18,
        'GEL' => 19,
        'JPY' => 55
      }.freeze

      # Converts a currency code to its corresponding integer representation.
      #
      # @param currency [String, Integer] the currency code (string like 'RUB') or integer code to validate.
      # @return [Integer] the integer representation of the currency code.
      # @raise [ArgumentError] if the currency code is invalid.
      def self.to_code(currency)
        return currency if currency.is_a?(Integer) && CURRENCY_CODES.value?(currency)
        return CURRENCY_CODES[currency] if currency.is_a?(String) && CURRENCY_CODES.key?(currency)

        raise ArgumentError, "Invalid currency code: #{currency}"
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'validatable'
require_relative 'currency_mapper'

module CDEKApiClient
  module Entities
    class Payment
      include Validatable

      attr_accessor :value, :currency

      validates :value, type: :integer, presence: true, positive: true
      validates :currency, type: :integer, presence: true

      def initialize(value:, currency:)
        @value = value
        @currency = CDEKApiClient::Entities::CurrencyMapper.to_code(currency)
        validate!
      end

      def to_json(*_args)
        {
          value: @value,
          currency: @currency
        }.to_json
      end
    end
  end
end

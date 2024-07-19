# frozen_string_literal: true
 
require_relative 'validatable'
require_relative 'payment'

module CDEKApiClient
  module Entities
    class Service
      include Validatable

      attr_accessor :code, :price, :name

      validates :code, type: :string, presence: true
      validates :price, type: :integer, presence: true
      validates :name, type: :string, presence: true

      def initialize(code:, price:, name:)
        @code = code
        @price = price
        @name = name
        validate!
      end

      def to_json(*_args)
        {
          code: @code,
          price: @price,
          name: @name
        }.to_json
      end
    end
  end
end
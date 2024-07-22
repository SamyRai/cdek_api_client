# frozen_string_literal: true

require_relative 'validatable'
require_relative 'payment'

module CDEKApiClient
  module Entities
    # Represents a service entity in the CDEK API.
    # Each service includes attributes such as code, price, and name.
    class Service
      include Validatable

      attr_accessor :code, :price, :name

      validates :code, type: :string, presence: true
      validates :price, type: :integer, presence: true
      validates :name, type: :string, presence: true

      # Initializes a new Service object.
      #
      # @param code [String] the code of the service.
      # @param price [Integer] the price of the service.
      # @param name [String] the name of the service.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(code:, price:, name:)
        @code = code
        @price = price
        @name = name
        validate!
      end

      # Converts the Service object to a JSON representation.
      #
      # @return [String] the JSON representation of the Service.
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

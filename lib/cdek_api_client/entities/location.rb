# frozen_string_literal: true

module CDEKApiClient
  module Entities
    class Location
      include Validatable

      attr_accessor :code, :city, :address

      validates :code, type: :integer, presence: true
      validates :city, type: :string
      validates :address, type: :string

      def initialize(code:, city: nil, address: nil)
        @code = code
        @city = city
        @address = address
        validate!
      end

      def to_json(*_args)
        {
          code: @code,
          city: @city,
          address: @address
        }.to_json
      end
    end
  end
end

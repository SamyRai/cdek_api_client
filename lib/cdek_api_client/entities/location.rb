# frozen_string_literal: true

module CDEKApiClient
  module Entities
    # Represents a location in the CDEK API.
    # Each location has attributes such as code, city, and address.
    class Location
      include Validatable

      attr_accessor :code, :city, :address

      validates :code, type: :integer, presence: true
      validates :city, type: :string
      validates :address, type: :string

      # Initializes a new Location object.
      #
      # @param code [Integer] the code of the location.
      # @param city [String, nil] the city of the location.
      # @param address [String, nil] the address of the location.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(code:, city: nil, address: nil)
        @code = code
        @city = city
        @address = address
        validate!
      end

      # Converts the Location object to a JSON representation.
      #
      # @return [String] the JSON representation of the Location.
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

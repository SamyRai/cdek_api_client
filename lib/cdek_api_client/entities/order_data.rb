# frozen_string_literal: true

require_relative 'validatable'
require_relative 'package'
require_relative 'recipient'
require_relative 'sender'

module CDEKApiClient
  module Entities
    # Represents the data required to create an order in the CDEK API.
    # Each order includes attributes such as type, number, tariff code, locations, recipient, sender, and packages.
    class OrderData
      include Validatable

      attr_accessor :type, :number, :tariff_code, :comment, :shipment_point, :delivery_point,
                    :from_location, :to_location, :recipient, :sender, :services, :packages

      validates :type, type: :integer, presence: true
      validates :number, type: :string, presence: true
      validates :tariff_code, type: :integer, presence: true
      validates :from_location, type: :object, presence: true
      validates :to_location, type: :object, presence: true
      validates :recipient, type: :object, presence: true
      validates :sender, type: :object, presence: true
      validates :packages, type: :array, presence: true, items: [Package]
      validates :comment, type: :string

      # Initializes a new OrderData object.
      #
      # @param type [Integer] the type of the order.
      # @param number [String] the order number.
      # @param tariff_code [Integer] the tariff code.
      # @param from_location [Location] the location details from where the order is shipped.
      # @param to_location [Location] the location details to where the order is shipped.
      # @param recipient [Recipient] the recipient details.
      # @param sender [Sender] the sender details.
      # @param packages [Array<Package>] the list of packages.
      # @param comment [String, nil] the comment for the order.
      # @param shipment_point [String, nil] the shipment point.
      # @param delivery_point [String, nil] the delivery point.
      # @param services [Array, nil] additional services.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(type:, number:, tariff_code:, from_location:, to_location:, recipient:, sender:, packages:,
                     comment: nil, shipment_point: nil, delivery_point: nil, services: [])
        @type = type
        @number = number
        @tariff_code = tariff_code
        @comment = comment
        @shipment_point = shipment_point
        @delivery_point = delivery_point
        @from_location = from_location
        @to_location = to_location
        @recipient = recipient
        @sender = sender
        @services = services
        @packages = packages
        validate!
      end

      # Converts the OrderData object to a JSON representation.
      #
      # @return [String] the JSON representation of the OrderData.
      def to_json(*_args)
        {
          type: @type,
          number: @number,
          tariff_code: @tariff_code,
          comment: @comment,
          shipment_point: @shipment_point,
          delivery_point: @delivery_point,
          from_location: @from_location,
          to_location: @to_location,
          recipient: @recipient,
          sender: @sender,
          services: @services,
          packages: @packages
        }.to_json
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'validatable'
require_relative 'package'
require_relative 'recipient'
require_relative 'sender'

module CDEKApiClient
  module Entities
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

      def initialize(type:, number:, tariff_code:, from_location:, to_location:, recipient:, sender:, packages:, comment: nil, shipment_point: nil, delivery_point: nil, services: [])
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
          packages: @packages,
        }.to_json
      end
    end
  end
end

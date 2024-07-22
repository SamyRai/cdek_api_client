# frozen_string_literal: true

require_relative 'validatable'
require_relative 'payment'

module CDEKApiClient
  module Entities
    # Represents an item in the CDEK API.
    # Each item has attributes such as ware key, payment, name, cost, amount, weight, and optional URL.
    class Item
      include Validatable

      attr_accessor :ware_key, :payment, :name, :cost, :amount, :weight, :url

      validates :ware_key, type: :string, presence: true
      validates :payment, type: :object, presence: true
      validates :name, type: :string, presence: true
      validates :cost, type: :integer, presence: true
      validates :amount, type: :integer, presence: true
      validates :weight, type: :integer, presence: true

      # Initializes a new Item object.
      #
      # @param ware_key [String] the ware key of the item.
      # @param payment [Payment] the payment details of the item.
      # @param name [String] the name of the item.
      # @param cost [Integer] the cost of the item.
      # @param amount [Integer] the amount of the item.
      # @param weight [Integer] the weight of the item.
      # @param url [String, nil] the optional URL of the item.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(ware_key:, payment:, name:, cost:, amount:, weight:, url: nil)
        @ware_key = ware_key
        @payment = payment
        @name = name
        @cost = cost
        @amount = amount
        @weight = weight
        @url = url
        validate!
      end

      # Converts the Item object to a JSON representation.
      #
      # @return [String] the JSON representation of the Item.
      def to_json(*_args)
        {
          ware_key: @ware_key,
          payment: @payment,
          name: @name,
          cost: @cost,
          amount: @amount,
          weight: @weight,
          url: @url
        }.to_json
      end
    end
  end
end

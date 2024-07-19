# frozen_string_literal: true

require_relative 'validatable'
require_relative 'payment'

module CDEKApiClient
  module Entities
    class Item
      include Validatable

      attr_accessor :ware_key, :payment, :name, :cost, :amount, :weight, :url

      validates :ware_key, type: :string, presence: true
      validates :payment, type: :object, presence: true
      validates :name, type: :string, presence: true
      validates :cost, type: :integer, presence: true
      validates :amount, type: :integer, presence: true
      validates :weight, type: :integer, presence: true

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

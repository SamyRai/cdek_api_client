# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents an invoice entity for printing invoices in the CDEK API.
    class Invoice
      include Validatable

      attr_accessor :orders, :copy_count, :type

      validates :orders, type: :array, presence: true, items: [{ type: :hash, presence: true }]
      validates :copy_count, type: :integer, presence: false
      validates :type, type: :string, presence: false

      # Initializes a new Invoice object.
      #
      # @param orders [Array<Hash>] the list of orders for invoice generation.
      # @param copy_count [Integer] the number of copies (default: 1).
      # @param type [String] the type of invoice.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(orders:, copy_count: 1, type: nil)
        @orders = orders
        @copy_count = copy_count
        @type = type
        validate!
      end

      # Creates an Invoice with orders UUIDs.
      #
      # @param orders_uuid [String, Array<String>] the order UUID(s).
      # @return [Invoice] the invoice instance.
      def self.with_orders_uuid(orders_uuid)
        orders = Array(orders_uuid).map do |uuid|
          { order_uuid: uuid }
        end
        new(orders: orders)
      end

      # Creates an Invoice with CDEK numbers.
      #
      # @param cdek_numbers [String, Array<String>] the CDEK number(s).
      # @return [Invoice] the invoice instance.
      def self.with_cdek_numbers(cdek_numbers)
        orders = Array(cdek_numbers).map do |number|
          { cdek_number: number }
        end
        new(orders: orders)
      end

      # Converts the Invoice object to a JSON representation.
      #
      # @return [String] the JSON representation of the Invoice.
      def to_json(*_args)
        data = { orders: @orders }
        data[:copy_count] = @copy_count if @copy_count
        data[:type] = @type if @type
        data.to_json
      end
    end
  end
end

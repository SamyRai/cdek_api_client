# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents a barcode entity for printing barcodes in the CDEK API.
    class Barcode
      include Validatable

      attr_accessor :orders, :copy_count, :type, :format, :lang

      validates :orders, type: :array, presence: true, items: [{ type: :hash, presence: true }]
      validates :copy_count, type: :integer, presence: false
      validates :type, type: :string, presence: false
      validates :format, type: :string, presence: false, inclusion: %w[A4 A5 A6]
      validates :lang, type: :string, presence: false

      # Initializes a new Barcode object.
      #
      # @param orders [Array<Hash>] the list of orders for barcode generation.
      # @param copy_count [Integer] the number of copies (default: 1).
      # @param type [String] the type of barcode.
      # @param format [String] the print format (A4, A5, A6).
      # @param lang [String] the language code.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(orders:, copy_count: 1, type: nil, format: 'A4', lang: nil)
        @orders = orders
        @copy_count = copy_count
        @type = type
        @format = format
        @lang = lang
        validate!
      end

      # Creates a Barcode with orders UUIDs.
      #
      # @param orders_uuid [String, Array<String>] the order UUID(s).
      # @return [Barcode] the barcode instance.
      def self.with_orders_uuid(orders_uuid)
        orders = Array(orders_uuid).map do |uuid|
          { order_uuid: uuid }
        end
        new(orders: orders)
      end

      # Creates a Barcode with CDEK numbers.
      #
      # @param cdek_numbers [String, Array<String>] the CDEK number(s).
      # @return [Barcode] the barcode instance.
      def self.with_cdek_numbers(cdek_numbers)
        orders = Array(cdek_numbers).map do |number|
          { cdek_number: number }
        end
        new(orders: orders)
      end

      # Converts the Barcode object to a JSON representation.
      #
      # @return [String] the JSON representation of the Barcode.
      def to_json(*_args)
        data = { orders: @orders }
        data[:copy_count] = @copy_count if @copy_count
        data[:type] = @type if @type
        data[:format] = @format if @format
        data[:lang] = @lang if @lang
        data.to_json
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'validatable'
require_relative 'item'

module CDEKApiClient
  module Entities
    # Represents a package entity in the CDEK API.
    # Each package includes attributes such as number, comment, height, length, weight, width, and items.
    class Package
      include Validatable

      attr_accessor :number, :comment, :height, :length, :weight, :width, :items

      validates :number, type: :string, presence: true
      validates :height, type: :integer, presence: true
      validates :length, type: :integer, presence: true
      validates :weight, type: :integer, presence: true
      validates :width, type: :integer, presence: true
      validates :items, type: :array, presence: true, items: [Item]

      # Initializes a new Package object.
      #
      # @param number [String] the package number.
      # @param comment [String] the comment for the package.
      # @param height [Integer] the height of the package.
      # @param length [Integer] the length of the package.
      # @param weight [Integer] the weight of the package.
      # @param width [Integer] the width of the package.
      # @param items [Array<Item>] the list of items in the package.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(number:, comment:, height:, length:, weight:, width:, items:)
        @number = number
        @comment = comment
        @height = height
        @length = length
        @weight = weight
        @width = width
        @items = items
        validate!
      end

      # Converts the Package object to a JSON representation.
      #
      # @return [String] the JSON representation of the Package.
      def to_json(*_args)
        {
          number: @number,
          comment: @comment,
          height: @height,
          length: @length,
          weight: @weight,
          width: @width,
          items: @items
        }.to_json
      end
    end
  end
end

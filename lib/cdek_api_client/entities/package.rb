# frozen_string_literal: true

require_relative 'validatable'
require_relative 'item'

module CDEKApiClient
  module Entities
    class Package
      include Validatable

      attr_accessor :number, :comment, :height, :length, :weight, :width, :items

      validates :number, type: :string, presence: true
      validates :height, type: :integer, presence: true
      validates :length, type: :integer, presence: true
      validates :weight, type: :integer, presence: true
      validates :width, type: :integer, presence: true
      validates :items, type: :array, presence: true, items: [Item]

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

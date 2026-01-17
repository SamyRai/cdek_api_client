# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents an agreement entity for delivery agreements in the CDEK API.
    class Agreement
      include Validatable

      attr_accessor :cdek_number, :date, :time_from, :time_to, :comment, :delivery_point, :to_location

      validates :cdek_number, type: :string, presence: true
      validates :date, type: :string, presence: true
      validates :time_from, type: :string, presence: true
      validates :time_to, type: :string, presence: true
      validates :comment, type: :string, presence: false
      validates :delivery_point, type: :string, presence: false
      validates :to_location, type: :hash, presence: false

      # Initializes a new Agreement object.
      #
      # @param cdek_number [String] the CDEK order number.
      # @param date [String] the delivery date in YYYY-MM-DD format.
      # @param time_from [String] the start time in HH:MM format.
      # @param time_to [String] the end time in HH:MM format.
      # @param comment [String] the comment for the agreement.
      # @param delivery_point [String] the delivery point code.
      # @param to_location [Location] the delivery location.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(cdek_number:, date:, time_from:, time_to:, comment: nil, delivery_point: nil, to_location: nil)
        @cdek_number = cdek_number
        @date = date
        @time_from = time_from
        @time_to = time_to
        @comment = comment
        @delivery_point = delivery_point
        @to_location = to_location
        validate!
      end

      # Converts the Agreement object to a JSON representation.
      #
      # @return [String] the JSON representation of the Agreement.
      def to_json(*_args)
        data = {
          cdek_number: @cdek_number,
          date: @date,
          time_from: @time_from,
          time_to: @time_to
        }
        data[:comment] = @comment if @comment
        data[:delivery_point] = @delivery_point if @delivery_point
        data[:to_location] = @to_location if @to_location
        data.to_json
      end
    end
  end
end

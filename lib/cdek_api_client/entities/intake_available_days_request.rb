# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents a request for available courier intake days from the CDEK API.
    class IntakeAvailableDaysRequest
      include Validatable

      attr_accessor :from_location, :date

      validates :from_location, type: :hash, presence: true
      validates :date, type: :string

      # Initializes a new IntakeAvailableDaysRequest object.
      #
      # @param from_location [Hash] the location details for the intake.
      # @param date [String, nil] the date up to which to get available days (optional).
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(from_location:, date: nil)
        @from_location = from_location
        @date = date
        validate!
      end

      # Converts the IntakeAvailableDaysRequest object to a JSON representation.
      #
      # @return [String] the JSON representation of the IntakeAvailableDaysRequest.
      def to_json(*_args)
        data = { from_location: @from_location }
        data[:date] = @date if @date
        data.to_json
      end
    end
  end
end

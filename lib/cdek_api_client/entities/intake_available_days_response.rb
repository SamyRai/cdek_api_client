# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents a response with available courier intake days from the CDEK API.
    class IntakeAvailableDaysResponse
      include Validatable

      attr_accessor :date, :all_days, :errors, :warnings

      validates :date, type: :array
      validates :all_days, type: :boolean
      validates :errors, type: :array
      validates :warnings, type: :array

      # Initializes a new IntakeAvailableDaysResponse object.
      #
      # @param date [Array<String>, nil] the available dates for intake.
      # @param all_days [Boolean, nil] whether all days are available.
      # @param errors [Array, nil] any errors in the response.
      # @param warnings [Array, nil] any warnings in the response.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(date: nil, all_days: nil, errors: nil, warnings: nil)
        @date = date
        @all_days = all_days
        @errors = errors || []
        @warnings = warnings || []
        validate!
      end

      # Converts the IntakeAvailableDaysResponse object to a JSON representation.
      #
      # @return [String] the JSON representation of the IntakeAvailableDaysResponse.
      def to_json(*_args)
        data = {}
        data[:date] = @date if @date
        data[:all_days] = @all_days unless @all_days.nil?
        data[:errors] = @errors unless @errors.empty?
        data[:warnings] = @warnings unless @warnings.empty?
        data.to_json
      end
    end
  end
end

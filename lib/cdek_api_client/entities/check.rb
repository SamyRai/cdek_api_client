# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents a check entity for retrieving check information in the CDEK API.
    class Check
      include Validatable

      attr_accessor :cdek_number, :date

      validates :cdek_number, type: :string, presence: false
      validates :date, type: :string, presence: false

      # Override validate! to allow both fields to be nil
      def validate!
        # Only validate non-nil fields
        validate_presence(:cdek_number, @cdek_number, { presence: false }) unless @cdek_number.nil?
        validate_type(:cdek_number, @cdek_number, { type: :string }) unless @cdek_number.nil?

        validate_presence(:date, @date, { presence: false }) unless @date.nil?
        validate_type(:date, @date, { type: :string }) unless @date.nil?
      end

      # Initializes a new Check object.
      #
      # @param cdek_number [String] the CDEK order number.
      # @param date [String] the date in YYYY-MM-DD format.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(cdek_number: nil, date: nil)
        @cdek_number = cdek_number
        @date = date
        validate!
      end

      # Converts the Check object to a hash for query parameters.
      #
      # @return [Hash] the query parameters.
      def to_query_params
        params = {}
        params[:cdek_number] = @cdek_number if @cdek_number
        params[:date] = @date if @date
        params
      end

      # Converts the Check object to a JSON representation.
      #
      # @return [String] the JSON representation of the Check.
      def to_json(*_args)
        to_query_params.to_json
      end
    end
  end
end

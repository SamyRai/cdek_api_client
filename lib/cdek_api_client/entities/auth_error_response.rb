# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents an OAuth authentication error response from the CDEK API.
    class AuthErrorResponse
      include Validatable

      attr_accessor :error, :error_description

      validates :error, type: :string, presence: true
      validates :error_description, type: :string, presence: true

      # Initializes a new AuthErrorResponse object.
      #
      # @param error [String] the error code.
      # @param error_description [String] the human-readable error description.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(error:, error_description:)
        @error = error
        @error_description = error_description
        validate!
      end

      # Converts the AuthErrorResponse object to a JSON representation.
      #
      # @return [String] the JSON representation of the AuthErrorResponse.
      def to_json(*_args)
        {
          error: @error,
          error_description: @error_description
        }.to_json
      end
    end
  end
end

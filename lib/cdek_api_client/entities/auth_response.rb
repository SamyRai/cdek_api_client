# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents an OAuth authentication response from the CDEK API.
    class AuthResponse
      include Validatable

      attr_accessor :access_token, :token_type, :expires_in, :scope, :jti

      validates :access_token, type: :string, presence: true
      validates :token_type, type: :string, presence: true
      validates :expires_in, type: :integer, presence: true
      validates :scope, type: :string, presence: true
      validates :jti, type: :string, presence: true

      # Initializes a new AuthResponse object.
      #
      # @param access_token [String] the access token for API authentication.
      # @param token_type [String] the type of token (usually "Bearer").
      # @param expires_in [Integer] the number of seconds until the token expires.
      # @param scope [String] the scope of the token.
      # @param jti [String] the unique identifier for the token.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(access_token:, token_type:, expires_in:, scope:, jti:)
        @access_token = access_token
        @token_type = token_type
        @expires_in = expires_in
        @scope = scope
        @jti = jti
        validate!
      end

      # Converts the AuthResponse object to a JSON representation.
      #
      # @return [String] the JSON representation of the AuthResponse.
      def to_json(*_args)
        {
          access_token: @access_token,
          token_type: @token_type,
          expires_in: @expires_in,
          scope: @scope,
          jti: @jti
        }.to_json
      end
    end
  end
end

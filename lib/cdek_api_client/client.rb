# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'json'
require 'logger'

module CDEKApiClient
  ##
  # Client class for interacting with the CDEK API.
  #
  # This class provides methods for authentication and initializing the API resources
  # for orders, locations, tariffs, and webhooks.
  #
  # @attr_reader [String] token The access token used for authentication.
  # @attr_reader [Logger] logger The logger used for logging HTTP requests and responses.
  # @attr_reader [Order] order The Order resource for interacting with order-related API endpoints.
  # @attr_reader [Location] location The Location resource for interacting with location-related API endpoints.
  # @attr_reader [Tariff] tariff The Tariff resource for interacting with tariff-related API endpoints.
  # @attr_reader [Webhook] webhook The Webhook resource for interacting with webhook-related API endpoints.
  class Client
    BASE_URL = ENV.fetch('CDEK_API_URL', 'https://api.edu.cdek.ru/v2')
    TOKEN_URL = "#{BASE_URL}/oauth/token".freeze

    attr_reader :token, :logger, :order, :location, :tariff, :webhook

    ##
    # Initializes a new Client object.
    #
    # @param [String] client_id The client ID for authentication.
    # @param [String] client_secret The client secret for authentication.
    # @param [Logger] logger The logger for logging HTTP requests and responses.
    def initialize(client_id, client_secret, logger: Logger.new($stdout))
      @client_id = client_id
      @client_secret = client_secret
      @logger = logger
      @token = authenticate

      @order = CDEKApiClient::Order.new(self)
      @location = CDEKApiClient::Location.new(self)
      @tariff = CDEKApiClient::Tariff.new(self)
      @webhook = CDEKApiClient::Webhook.new(self)
    end

    ##
    # Authenticates with the CDEK API and retrieves an access token.
    #
    # @return [String] The access token.
    # @raise [Error] if there is an error getting the token.
    def authenticate
      response = connection.post(TOKEN_URL) do |req|
        req.body = {
          grant_type: 'client_credentials',
          client_id: @client_id,
          client_secret: @client_secret
        }
      end

      raise Error, "Error getting token: #{response.body}" unless response.success?

      response.body['access_token']
    end

    ##
    # Creates a Faraday connection object.
    #
    # @return [Faraday::Connection] The Faraday connection object.
    def connection
      Faraday.new(url: BASE_URL) do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
        conn.response :logger, @logger, bodies: true
      end
    end

    ##
    # Creates a Faraday connection object with authorization.
    #
    # @return [Faraday::Connection] The Faraday connection object with authorization.
    def auth_connection
      Faraday.new(url: BASE_URL) do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.authorization :Bearer, @token
        conn.adapter Faraday.default_adapter
        conn.response :logger, @logger, bodies: true
      end
    end

    ##
    # Handles the response from the API.
    #
    # @param [Faraday::Response] response The response object.
    # @return [Hash] The parsed response body.
    # @raise [Error] if the response is not successful.
    def handle_response(response)
      raise Error, "Error: #{response.body}" unless response.success?

      response.body
    end

    ##
    # Validates the format of a UUID.
    #
    # @param [String] uuid The UUID to validate.
    # @raise [RuntimeError] if the UUID format is invalid.
    def validate_uuid(uuid)
      return if uuid.match?(/\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\z/)

      raise 'Invalid UUID format'
    end
  end
end

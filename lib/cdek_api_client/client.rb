# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'logger'
require_relative 'api/location'
require_relative 'api/order'
require_relative 'api/tariff'
require_relative 'api/webhook'

module CDEKApiClient
  # Client class for interacting with the CDEK API.
  class Client
    BASE_URL = ENV.fetch('CDEK_API_URL', 'https://api.edu.cdek.ru/v2')
    TOKEN_URL = "#{BASE_URL}/oauth/token".freeze

    # @return [String] the access token for API authentication.
    attr_reader :token
    # @return [Logger] the logger instance.
    attr_reader :logger
    # @return [CDEKApiClient::Order] the order API interface.
    attr_reader :order
    # @return [CDEKApiClient::Location] the location API interface.
    attr_reader :location
    # @return [CDEKApiClient::Tariff] the tariff API interface.
    attr_reader :tariff
    # @return [CDEKApiClient::Webhook] the webhook API interface.
    attr_reader :webhook

    # Initializes the client with API credentials and logger.
    #
    # @param client_id [String] the client ID.
    # @param client_secret [String] the client secret.
    # @param logger [Logger] the logger instance.
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

    # Authenticates with the API and retrieves an access token.
    #
    # @return [String] the access token.
    # @raise [StandardError] if authentication fails.
    def authenticate
      uri = URI(TOKEN_URL)
      response = Net::HTTP.post_form(uri, {
                                       grant_type: 'client_credentials',
                                       client_id: @client_id,
                                       client_secret: @client_secret
                                     })

      raise "Error getting token: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)['access_token']
    end

    # Makes an HTTP request to the API.
    #
    # @param method [String] the HTTP method (e.g., 'get', 'post').
    # @param path [String] the API endpoint path.
    # @param body [Hash, nil] the request body.
    # @return [Hash, Array] the parsed response.
    def request(method, path, body: nil)
      uri = URI("#{BASE_URL}/#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request_class = Net::HTTP.const_get(method.capitalize)
      request = request_class.new(uri.request_uri)
      request['Authorization'] = "Bearer #{@token}"
      request['Content-Type'] = 'application/json'
      request.body = body.to_json if body

      response = http.request(request)
      handle_response(response)
    rescue StandardError => e
      @logger.error("HTTP request failed: #{e.message}")
      { 'error' => e.message }
    end

    private

    # Handles the API response, parsing JSON and handling errors.
    #
    # @param response [Net::HTTPResponse] the HTTP response.
    # @return [Hash, Array] the parsed response.
    def handle_response(response)
      case response
      when Net::HTTPSuccess
        response_body = response.body
        parsed_response = JSON.parse(response_body)

        if parsed_response.is_a?(Hash) && parsed_response.key?('error')
          error_message = parsed_response['error']
          @logger.error("API Error: #{error_message}")
          { 'error' => error_message }
        else
          parsed_response
        end
      when Array
        response
      when Hash
        response
      else
        error_message = "Unexpected response type: #{response.class}"
        @logger.error(error_message)
        { 'error' => error_message }
      end
    rescue JSON::ParserError => e
      error_message = "Failed to parse response: #{e.message}"
      @logger.error(error_message)
      { 'error' => error_message }
    end

    # Parses a JSON string, handling any parsing errors.
    #
    # @param body [String] the JSON string to parse.
    # @return [Hash] the parsed JSON.
    def parse_json(body)
      JSON.parse(body)
    rescue JSON::ParserError => e
      error_message = "Failed to parse JSON body: #{e.message}"
      @logger.error(error_message)
      { 'error' => error_message }
    end
  end
end

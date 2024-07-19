# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'json'
require 'logger'

module CDEKApiClient
  class Client
    BASE_URL = ENV.fetch('CDEK_API_URL', 'https://api.edu.cdek.ru/v2')
    TOKEN_URL = "#{BASE_URL}/oauth/token"

    attr_reader :token, :logger, :order, :location, :tariff, :webhook

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

    def authenticate
      response = connection.post(TOKEN_URL) do |req|
        req.body = {
          grant_type: 'client_credentials',
          client_id: @client_id,
          client_secret: @client_secret
        }
      end

      if response.success?
        response.body['access_token']
      else
        raise Error, "Error getting token: #{response.body}"
      end
    end

    def connection
      Faraday.new(url: BASE_URL) do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
        conn.response :logger, @logger, bodies: true
      end
    end

    def auth_connection
      Faraday.new(url: BASE_URL) do |conn|
        conn.request :url_encoded
        conn.response :json, content_type: /\bjson$/
        conn.authorization :Bearer, @token
        conn.adapter Faraday.default_adapter
        conn.response :logger, @logger, bodies: true
      end
    end

    def handle_response(response)
      if response.success?
        response.body
      else
        raise Error, "Error: #{response.body}"
      end
    end

    def validate_uuid(uuid)
      raise 'Invalid UUID format' unless uuid.match?(/\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[4][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\z/)
    end
  end
end

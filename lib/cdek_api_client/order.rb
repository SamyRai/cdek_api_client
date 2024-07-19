# frozen_string_literal: true

require 'cdek_api_client/entities/order_data'

module CDEKApiClient
  class Order
    BASE_URL = ENV.fetch('CDEK_API_URL', 'https://api.edu.cdek.ru/v2')
    ORDERS_URL = "#{BASE_URL}/orders"

    def initialize(client)
      @client = client
    end

    def create(order_data)
      validate_order_data(order_data)

      response = @client.auth_connection.post(ORDERS_URL) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = order_data.to_json
      end
      handle_response(response)
    end

    def track(order_uuid)
      @client.validate_uuid(order_uuid)

      response = @client.auth_connection.get("#{ORDERS_URL}/#{order_uuid}") do |req|
        req.headers['Content-Type'] = 'application/json'
      end
      handle_response(response)
    end

    private

    def validate_order_data(order_data)
      raise 'order_data must be a Hash' unless order_data.is_a?(Entities::OrderData)
    end

    def handle_response(response)
      @client.send(:handle_response, response)
    end
  end
end

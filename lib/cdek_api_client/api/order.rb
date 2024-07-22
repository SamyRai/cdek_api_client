# frozen_string_literal: true

module CDEKApiClient
  # Handles order-related API requests.
  class Order
    # Initializes the Order object.
    #
    # @param client [CDEKApiClient::Client] the client instance.
    def initialize(client)
      @client = client
    end

    # Creates a new order.
    #
    # @param order_data [CDEKApiClient::Entities::OrderData] the data for the order.
    # @return [Hash] the response from the API.
    def create(order_data)
      response = @client.request('post', 'orders', body: order_data)
      handle_response(response)
    end

    # Tracks an order by its UUID.
    #
    # @param order_uuid [String] the UUID of the order.
    # @return [Hash] the tracking information.
    def track(order_uuid)
      response = @client.request('get', "orders/#{order_uuid}")
      handle_response(response)
    end

    private

    # Handles the response from the API.
    #
    # @param response [Net::HTTPResponse] the response from the API.
    # @return [Hash] the parsed response.
    def handle_response(response)
      @client.send(:handle_response, response)
    end
  end
end

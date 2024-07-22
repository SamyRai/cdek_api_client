# lib/cdek_api_client/order.rb
# frozen_string_literal: true

module CDEKApiClient
  class Order
    def initialize(client)
      @client = client
    end

    def create(order_data)
      response = @client.request('post', 'orders', body: order_data)
      handle_response(response)
    end

    def track(order_uuid)
      response = @client.request('get', "orders/#{order_uuid}")
      handle_response(response)
    end

    private

    def handle_response(response)
      @client.send(:handle_response, response)
    end
  end
end

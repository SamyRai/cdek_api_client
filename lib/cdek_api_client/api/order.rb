# frozen_string_literal: true

module CDEKApiClient
  module API
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

      # Deletes an order by its UUID.
      #
      # @param order_uuid [String] the UUID of the order to delete.
      # @return [Hash] the response from the API.
      def delete(order_uuid)
        validate_uuid(order_uuid)
        response = @client.request('delete', "orders/#{order_uuid}")
        handle_response(response)
      end

      # Cancels an order by its UUID.
      #
      # @param order_uuid [String] the UUID of the order to cancel.
      # @return [Hash] the response from the API.
      def cancel(order_uuid)
        validate_uuid(order_uuid)
        response = @client.request('post', "orders/#{order_uuid}/refusal")
        handle_response(response)
      end

      # Updates an existing order.
      #
      # @param order_data [CDEKApiClient::Entities::OrderData] the updated order data.
      # @return [Hash] the response from the API.
      def update(order_data)
        response = @client.request('patch', 'orders', body: order_data)
        handle_response(response)
      end

      # Gets order information by CDEK number.
      #
      # @param cdek_number [String] the CDEK order number.
      # @return [Hash] the order information.
      def get_by_cdek_number(cdek_number)
        response = @client.request('get', 'orders', query: { cdek_number: cdek_number })
        handle_response(response)
      end

      # Gets order information by IM number.
      #
      # @param im_number [String] the IM order number.
      # @return [Hash] the order information.
      def get_by_im_number(im_number)
        response = @client.request('get', 'orders', query: { im_number: im_number })
        handle_response(response)
      end

      private

      # Validates UUID format.
      #
      # @param uuid [String] the UUID to validate.
      # @raise [ArgumentError] if the UUID format is invalid.
      def validate_uuid(uuid)
        @client.validate_uuid(uuid)
      end

      # Handles the response from the API.
      #
      # @param response [Net::HTTPResponse] the response from the API.
      # @return [Hash] the parsed response.
      def handle_response(response)
        @client.send(:handle_response, response)
      end
    end
  end
end

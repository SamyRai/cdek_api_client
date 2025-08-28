# frozen_string_literal: true

module CDEKApiClient
  module API
    # Handles order tracking requests to the CDEK API.
    class TrackOrder
      BASE_URL = ENV.fetch('CDEK_API_URL', 'https://api.edu.cdek.ru/v2')
      TRACK_ORDER_URL = "#{BASE_URL}/orders/%<uuid>s".freeze

      # Initializes the TrackOrder object.
      #
      # @param client [CDEKApiClient::Client] the client instance.
      def initialize(client)
        @client = client
      end

      # Retrieves tracking information for an order.
      #
      # @param order_uuid [String] the UUID of the order.
      # @return [Hash] the tracking information.
      # @raise [ArgumentError] if the UUID is invalid.
      def get(order_uuid)
        validate_uuid(order_uuid)

        response = @client.request('get', "orders/#{order_uuid}")
        handle_response(response)
      end

      private

      # Validates the order UUID.
      #
      # @param uuid [String] the UUID to validate.
      # @raise [ArgumentError] if the UUID is invalid.
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

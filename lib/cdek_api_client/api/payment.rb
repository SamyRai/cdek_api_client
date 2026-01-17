# frozen_string_literal: true

module CDEKApiClient
  module API
    # Handles payment and registry-related API requests.
    class Payment
      # Initializes the Payment object.
      #
      # @param client [CDEKApiClient::Client] the client instance.
      def initialize(client)
        @client = client
      end

      # Gets payment information for a specific date.
      #
      # @param date [String] the date in YYYY-MM-DD format.
      # @return [Hash] the payment information.
      def get_payments(date)
        response = @client.request('get', 'payment', query: { date: date })
        handle_response(response)
      end

      # Gets check information.
      #
      # @param check_data [CDEKApiClient::Entities::Check] the check data.
      # @return [Hash] the check information.
      def get_checks(check_data)
        response = @client.request('get', 'check', query: check_data)
        handle_response(response)
      end

      # Gets registry information for a specific date.
      #
      # @param date [String] the date in YYYY-MM-DD format.
      # @return [Hash] the registry information.
      def get_registries(date)
        response = @client.request('get', 'registries', query: { date: date })
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
end

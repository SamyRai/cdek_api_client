# frozen_string_literal: true

module CDEKApiClient
  module API
    # Handles tariff-related API requests.
    class Tariff
      # Initializes the Tariff object.
      #
      # @param client [CDEKApiClient::Client] the client instance.
      def initialize(client)
        @client = client
      end

      # Calculates the tariff.
      #
      # @param tariff_data [CDEKApiClient::Entities::TariffData] the data for the tariff calculation.
      # @return [Hash] the response from the API.
      def calculate(tariff_data)
        @client.request('post', 'calculator/tariff', body: tariff_data)
      end

      # Calculates all available tariffs.
      #
      # @param tariff_data [CDEKApiClient::Entities::TariffData] the data for the tariff calculation.
      # @return [Array<Hash>] the list of available tariffs.
      def calculate_list(tariff_data)
        response = @client.request('post', 'calculator/tarifflist', body: tariff_data)
        response.is_a?(Hash) && response.key?('tariff_codes') ? response['tariff_codes'] : response
      end
    end
  end
end

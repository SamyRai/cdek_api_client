# frozen_string_literal: true

module CDEKApiClient
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
  end
end

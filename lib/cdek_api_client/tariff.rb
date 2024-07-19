# frozen_string_literal: true

module CDEKApiClient
  class Tariff
    BASE_URL = ENV.fetch('CDEK_API_URL', 'https://api.edu.cdek.ru/v2')
    TARIFF_URL = "#{BASE_URL}/calculator/tariff"

    def initialize(client)
      @client = client
    end

    def calculate(tariff_data)
      validate_tariff_data(tariff_data)

      response = @client.auth_connection.post(TARIFF_URL) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = tariff_data.to_json
      end
      handle_response(response)
    end

    private

    def validate_tariff_data(tariff_data)
      raise 'tariff_data must be a Hash' unless tariff_data.is_a?(Entities::TariffData)
    end

    def handle_response(response)
      @client.send(:handle_response, response)
    end
  end
end

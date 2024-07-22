# frozen_string_literal: true

module CDEKApiClient
  class Tariff
    def initialize(client)
      @client = client
    end

    def calculate(tariff_data)
      @client.request('post', 'calculator/tariff', body: tariff_data)
    end
  end
end

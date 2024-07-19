# frozen_string_literal: true

module CDEKApiClient
  class Location
    CITIES_URL = 'location/cities'
    REGIONS_URL = 'location/regions'

    def initialize(client)
      @client = client
    end

    def cities
      response = @client.auth_connection.get(CITIES_URL) do |req|
        req.headers['Content-Type'] = 'application/json'
      end
      handle_response(response)
    end

    def regions
      response = @client.auth_connection.get(REGIONS_URL) do |req|
        req.headers['Content-Type'] = 'application/json'
      end
      handle_response(response)
    end

    private

    def handle_response(response)
      @client.send(:handle_response, response)
    end
  end
end

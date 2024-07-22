# lib/cdek_api_client/location.rb
# frozen_string_literal: true

require 'net/http'
require 'json'

module CDEKApiClient
  class Location
    def initialize(client)
      @client = client
    end

    def cities
      @client.request('get', 'location/cities')
    end

    def regions
      @client.request('get', 'location/regions')
    end

    def offices
      @client.request('get', 'deliverypoints')
    end

    def postal_codes(city_code)
      if city_code
        @client.request('get', "location/postalcodes?code=#{city_code}")
      else
        @client.request('get', '/location/postalcodes')
      end
    end
  end
end

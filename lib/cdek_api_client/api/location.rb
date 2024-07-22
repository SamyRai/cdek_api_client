# frozen_string_literal: true

require 'json'

module CDEKApiClient
  class Location
    def initialize(client)
      @client = client
    end

    def cities(use_live_data: false)
      use_live_data ? @client.request('get', 'location/cities') : read_data_from_file('cities_mapping.json')
    end

    def regions(use_live_data: false)
      use_live_data ? @client.request('get', 'location/regions') : read_data_from_file('regions_mapping.json')
    end

    def offices(use_live_data: false)
      use_live_data ? @client.request('get', 'deliverypoints') : read_data_from_file('offices_mapping.json')
    end

    def postal_codes(city_code = nil, use_live_data: false)
      if use_live_data
        if city_code
          @client.request('get',
                          "location/postalcodes?code=#{city_code}")
        else
          @client.request('get',
                          'location/postalcodes')
        end
      else
        read_data_from_file('postal_codes_mapping.json')
      end
    end

    private

    def read_data_from_file(filename)
      file_path = File.join('data', filename)
      JSON.parse(File.read(file_path))
    rescue StandardError => e
      @client.logger.error("Failed to read data from file: #{e.message}")
      { 'error' => e.message }
    end
  end
end

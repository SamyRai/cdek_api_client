# frozen_string_literal: true

require 'json'

module CDEKApiClient
  module API
    # Handles location-related API requests.
    class Location
      # Initializes the Location object.
      #
      # @param client [CDEKApiClient::Client] the client instance.
      def initialize(client)
        @client = client
      end

      # Retrieves a list of cities.
      #
      # @param use_live_data [Boolean] whether to use live data or cached data.
      # @return [Array<Hash>] list of cities.
      def cities(use_live_data: false)
        use_live_data ? @client.request('get', 'location/cities') : read_data_from_file('cities_mapping.json')
      end

      # Retrieves a list of regions.
      #
      # @param use_live_data [Boolean] whether to use live data or cached data.
      # @return [Array<Hash>] list of regions.
      def regions(use_live_data: false)
        use_live_data ? @client.request('get', 'location/regions') : read_data_from_file('regions_mapping.json')
      end

      # Retrieves a list of offices.
      #
      # @param use_live_data [Boolean] whether to use live data or cached data.
      # @return [Array<Hash>] list of offices.
      def offices(use_live_data: false)
        use_live_data ? @client.request('get', 'deliverypoints') : read_data_from_file('offices_mapping.json')
      end

      # Retrieves a list of postal codes.
      #
      # @param city_code [String, nil] the city code to filter postal codes.
      # @param use_live_data [Boolean] whether to use live data or cached data.
      # @return [Array<Hash>] list of postal codes.
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

      # Reads data from a file.
      #
      # @param filename [String] the name of the file to read.
      # @return [Hash] the parsed JSON data from the file.
      def read_data_from_file(filename)
        file_path = File.join('data', filename)
        JSON.parse(File.read(file_path))
      rescue StandardError => e
        @client.logger.error("Failed to read data from file: #{e.message}")
        { 'error' => e.message }
      end
    end
  end
end

# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client'
require 'json'

RSpec.describe CDEKApiClient::API::Location, :vcr do
  include ClientHelper

  let(:location) { client.location }

  def save_response_to_file(response, filename)
    File.write("data/#{filename}", JSON.pretty_generate(response))
  end

  describe '#cities' do
    context 'when using live data' do
      it 'retrieves a list of cities successfully' do
        VCR.use_cassette('list_cities') do
          response = location.cities(use_live_data: true)
          expect(response).to be_an(Array)
        end
      end

      it 'checks the first city has a city key' do
        VCR.use_cassette('list_cities') do
          response = location.cities(use_live_data: true)
          expect(response.first).to have_key('city')
        end
      end

      # This test is here only to populate the cities_mapping.json file
      it 'saves cities to filesystem' do # rubocop:disable RSpec/NoExpectationExample
        VCR.use_cassette('list_cities') do
          response = location.cities(use_live_data: true)
          save_response_to_file(response, 'cities_mapping.json')
        end
      end
    end

    context 'when using cached data' do
      it 'retrieves a list of cities from the file system' do
        response = location.cities
        expect(response).to be_an(Array)
      end

      it 'checks the first city has a city key' do
        response = location.cities
        expect(response.first).to have_key('city')
      end
    end
  end

  describe '#regions' do
    context 'when using live data' do
      it 'retrieves a list of regions successfully' do
        VCR.use_cassette('list_regions') do
          response = location.regions(use_live_data: true)
          expect(response).to be_an(Array)
        end
      end

      it 'checks the first region has a region key' do
        VCR.use_cassette('list_regions') do
          response = location.regions(use_live_data: true)
          expect(response.first).to have_key('region')
        end
      end

      # This test is here only to populate the regions_mapping.json file
      it 'saves regions to filesystem' do # rubocop:disable RSpec/NoExpectationExample
        VCR.use_cassette('list_regions') do
          response = location.regions(use_live_data: true)
          save_response_to_file(response, 'regions_mapping.json')
        end
      end
    end

    context 'when using cached data' do
      it 'retrieves a list of regions from the file system' do
        response = location.regions
        expect(response).to be_an(Array)
      end

      it 'checks the first region has a region key' do
        response = location.regions
        expect(response.first).to have_key('region')
      end
    end
  end

  describe '#offices' do
    context 'when using live data' do
      it 'retrieves a list of offices successfully' do
        VCR.use_cassette('list_offices') do
          response = location.offices(use_live_data: true)
          expect(response).to be_an(Array)
        end
      end

      it 'checks the first office has a code key' do
        VCR.use_cassette('list_offices') do
          response = location.offices(use_live_data: true)
          expect(response.first).to have_key('code')
        end
      end

      # This test is here only to populate the offices_mapping.json file
      it 'saves offices to filesystem' do # rubocop:disable RSpec/NoExpectationExample
        VCR.use_cassette('list_offices') do
          response = location.offices(use_live_data: true)
          save_response_to_file(response, 'offices_mapping.json')
        end
      end
    end

    context 'when using cached data' do
      it 'retrieves a list of offices from the file system' do
        response = location.offices
        expect(response).to be_an(Array)
      end

      it 'checks the first office has a code key' do
        response = location.offices
        expect(response.first).to have_key('code')
      end
    end

    it 'handles errors gracefully' do
      allow(location).to receive(:offices).and_raise(StandardError, 'An error occurred')
      expect { location.offices }.to raise_error(StandardError, 'An error occurred')
    end
  end

  describe '#cities_with_postal_codes' do
    it 'retrieves cities and their postal codes successfully' do
      VCR.use_cassette('list_cities_with_postal') do
        cities_response = location.cities(use_live_data: true)
        expect(cities_response).to be_an(Array)
      end
    end

    it 'checks the first city has a code key' do
      VCR.use_cassette('list_cities_with_postal') do
        cities_response = location.cities(use_live_data: true)
        expect(cities_response.first).to have_key('code')
      end
    end

    # This test is here only to populate the cities_with_postal_codes_mapping.json file
    it 'retrieves postal codes for each city and saves to filesystem' do # rubocop:disable RSpec/NoExpectationExample
      VCR.use_cassette('list_cities_with_postal') do
        cities_response = location.cities(use_live_data: true)
        cities_with_postal_codes = cities_response.map do |city|
          city_code = city['code']
          postal_codes_response = location.postal_codes(city_code, use_live_data: true)
          {
            city:,
            postal_codes: postal_codes_response
          }
        end
        save_response_to_file(cities_with_postal_codes, 'cities_with_postal_codes_mapping.json')
      end
    rescue StandardError => e
      puts "Error retrieving cities or postal codes: #{e.message}"
      raise e
    end
  end
end

# spec/models/location_spec.rb
# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client'
require 'json'

RSpec.describe CDEKApiClient::Location, :vcr do
  let(:client_id) { 'wqGwiQx0gg8mLtiEKsUinjVSICCjtTEP' }
  let(:client_secret) { 'RmAmgvSgSl1yirlz9QupbzOJVqhCxcP5' }
  let(:client) { CDEKApiClient::Client.new(client_id, client_secret) }
  let(:location) { client.location }

  def save_response_to_file(response, filename)
    File.write("data/#{filename}", JSON.pretty_generate(response))
  end

  describe '#cities' do
    it 'retrieves a list of cities successfully and saves to filesystem' do
      VCR.use_cassette('list_cities') do
        response = location.cities(use_live_data: true)
        expect(response).to be_an(Array)
        expect(response.first).to have_key('city')
        save_response_to_file(response, 'cities_mapping.json')
      end
    end

    it 'retrieves a list of cities from the file system' do
      response = location.cities
      expect(response).to be_an(Array)
      expect(response.first).to have_key('city')
    end
  end

  describe '#regions' do
    it 'retrieves a list of regions successfully and saves to filesystem' do
      VCR.use_cassette('list_regions') do
        response = location.regions(use_live_data: true)
        expect(response).to be_an(Array)
        expect(response.first).to have_key('region')
        save_response_to_file(response, 'regions_mapping.json')
      end
    end

    it 'retrieves a list of regions from the file system' do
      response = location.regions
      expect(response).to be_an(Array)
      expect(response.first).to have_key('region')
    end
  end

  describe '#offices' do
    it 'retrieves a list of offices successfully and saves to filesystem' do
      VCR.use_cassette('list_offices') do
        response = location.offices(use_live_data: true)
        expect(response).to be_an(Array)
        expect(response.first).to have_key('code')
        save_response_to_file(response, 'offices_mapping.json')
      end
    rescue StandardError => e
      puts "Error retrieving offices: #{e.message}"
      raise e
    end

    it 'retrieves a list of offices from the file system' do
      response = location.offices
      expect(response).to be_an(Array)
      expect(response.first).to have_key('code')
    end
  end

  describe '#cities_with_postal_codes' do
    it 'retrieves cities and their postal codes successfully and saves to filesystem' do
      VCR.use_cassette('list_cities_wiht_postal') do
        cities_response = location.cities(use_live_data: true)
        expect(cities_response).to be_an(Array)
        expect(cities_response.first).to have_key('code')

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

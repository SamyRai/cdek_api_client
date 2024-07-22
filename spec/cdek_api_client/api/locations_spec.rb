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
    File.open("data/"+filename, 'w') do |f|
      f.write(JSON.pretty_generate(response))
    end
  end

  describe '#cities' do
    it 'retrieves a list of cities successfully and saves to filesystem' do
      VCR.use_cassette('list_cities') do
        response = location.cities
        expect(response).to be_an(Array)
        expect(response.first).to have_key('city')
        save_response_to_file(response, 'cities_mapping.json')
      end
    end
  end

  describe '#regions' do
    it 'retrieves a list of regions successfully and saves to filesystem' do
      VCR.use_cassette('list_regions') do
        response = location.regions
        expect(response).to be_an(Array)
        expect(response.first).to have_key('region')
        save_response_to_file(response, 'regions_mapping.json')
      end
    end
  end

  describe '#offices' do
    it 'retrieves a list of offices successfully and saves to filesystem' do
      VCR.use_cassette('list_offices') do
        response = location.offices
        expect(response).to be_an(Array)
        expect(response.first).to have_key('code')
        save_response_to_file(response, 'offices_mapping.json')
      end
    rescue => e
      puts "Error retrieving offices: #{e.message}"
      raise e
    end
  end

  describe '#cities_with_postal_codes' do
    it 'retrieves cities and their postal codes successfully and saves to filesystem' do
      VCR.use_cassette('list_cities_wiht_postal') do
        cities_response = location.cities
        expect(cities_response).to be_an(Array)
        expect(cities_response.first).to have_key('code')

        cities_with_postal_codes = cities_response.map do |city|
          city_code = city['code']
          postal_codes_response = location.postal_codes(city_code)
          {
            city: city,
            postal_codes: postal_codes_response
          }
        end

        save_response_to_file(cities_with_postal_codes, 'cities_with_postal_codes_mapping.json')
      end
    rescue => e
      puts "Error retrieving cities or postal codes: #{e.message}"
      raise e
    end
  end
  # describe '#postal_codes' do
  #   it 'retrieves a list of postal codes successfully and saves to filesystem' do
  #     VCR.use_cassette('list_postal_codes') do
  #       response = location.postal_codes
  #       expect(response).to be_an(Array)
  #       expect(response.first).to have_key('postal_codes')
  #       save_response_to_file(response, 'postal_codes_mapping.json')
  #     end
  #   rescue => e
  #     puts "Error retrieving postal codes: #{e.message}"
  #     raise e
  #   end
  # end
end

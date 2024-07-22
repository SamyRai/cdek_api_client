# spec/cdek_api_client/models/client_spec.rb
# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client'

RSpec.describe CDEKApiClient::Client, :vcr do
  let(:client_id) { 'wqGwiQx0gg8mLtiEKsUinjVSICCjtTEP' }
  let(:client_secret) { 'RmAmgvSgSl1yirlz9QupbzOJVqhCxcP5' }
  let(:client) { described_class.new(client_id, client_secret) }

  describe '#initialize' do
    it 'initializes submodules correctly' do
      expect(client.order).to be_a(CDEKApiClient::Order)
      expect(client.location).to be_a(CDEKApiClient::Location)
      expect(client.tariff).to be_a(CDEKApiClient::Tariff)
      expect(client.webhook).to be_a(CDEKApiClient::Webhook)
    end
  end

  describe '#authenticate' do
    it 'authenticates and retrieves an access token' do
      VCR.use_cassette('authenticate') do
        token = client.authenticate
        expect(token).not_to be_nil
        expect(token).to be_a(String)
      end
    end

    it 'raises an error if authentication fails' do
      allow(Net::HTTP).to receive(:post_form).and_return(double('response', is_a?: false, body: 'Error'))
      expect { client.authenticate }.to raise_error(RuntimeError, 'Error getting token: Error')
    end
  end
end

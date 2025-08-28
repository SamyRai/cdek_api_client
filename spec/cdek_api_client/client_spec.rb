# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CDEKApiClient::Client do
  include ClientHelper

  describe '#initialize' do
    it 'initializes submodules correctly' do
      expect(client.order).to be_a(CDEKApiClient::API::Order)
      expect(client.location).to be_a(CDEKApiClient::API::Location)
      expect(client.tariff).to be_a(CDEKApiClient::API::Tariff)
      expect(client.webhook).to be_a(CDEKApiClient::API::Webhook)
    end
  end

  describe '#authenticate' do
    context 'when authentication is successful' do
      it 'retrieves an access token' do
        expect(client.token).to be_a(String)
      end
    end

    context 'when authentication fails' do
      before do
        stub_request(:post, 'https://api.edu.cdek.ru/v2/oauth/token')
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'raises an error' do
        expect { client }.to raise_error(RuntimeError, 'Error getting token: Internal Server Error')
      end
    end
  end

  describe '#request' do
    before do
      allow_any_instance_of(described_class).to receive(:authenticate).and_return('test_token')
    end

    context 'when the request fails' do
      before do
        allow_any_instance_of(Net::HTTP).to receive(:request).and_raise(StandardError, 'test error')
      end

      it 'returns an error hash' do
        response = client.request('get', 'test_path')
        expect(response).to eq({ 'error' => 'test error' })
      end
    end

    context 'when the response is not successful' do
      before do
        stub_request(:get, 'https://api.edu.cdek.ru/v2/test_path')
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'returns an error hash' do
        response = client.request('get', 'test_path')
        expect(response).to eq({ 'error' => { 'error' => "Failed to parse JSON body: unexpected token 'Internal' at line 1 column 1" } })
      end
    end

    context 'when the response body is not a valid JSON' do
      before do
        stub_request(:get, 'https://api.edu.cdek.ru/v2/test_path')
          .to_return(status: 200, body: 'invalid json')
      end

      it 'returns an error hash' do
        response = client.request('get', 'test_path')
        expect(response['error']).to match(/Failed to parse JSON body/)
      end
    end
  end
end

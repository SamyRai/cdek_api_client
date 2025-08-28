# frozen_string_literal: true

require 'spec_helper'
require 'securerandom'
require_relative '../../../lib/cdek_api_client/api/track_order'

RSpec.describe CDEKApiClient::API::TrackOrder do
  include ClientHelper

  let(:track_order_api) { described_class.new(client) }
  let(:order_uuid) { SecureRandom.uuid }

  describe '#get' do
    context 'with a valid uuid' do
      before do
        stub_request(:get, "https://api.edu.cdek.ru/v2/orders/#{order_uuid}")
          .to_return(status: 200, body: { 'entity' => { 'uuid' => order_uuid } }.to_json, headers: {})
      end

      it 'returns the tracking information' do
        response = track_order_api.get(order_uuid)
        expect(response['entity']['uuid']).to eq(order_uuid)
      end
    end

    context 'with an invalid uuid' do
      it 'raises an ArgumentError' do
        expect { track_order_api.get('invalid_uuid') }.to raise_error(ArgumentError, 'Invalid UUID format')
      end
    end

    context 'when the API returns an error' do
      before do
        stub_request(:get, "https://api.edu.cdek.ru/v2/orders/#{order_uuid}")
          .to_return(status: 500, body: { 'error' => 'Internal Server Error' }.to_json, headers: {})
      end

      it 'returns an error hash' do
        response = track_order_api.get(order_uuid)
        expect(response['error']['error']).to eq('Internal Server Error')
      end
    end
  end
end

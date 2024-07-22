# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CDEKApiClient::API::Webhook, :vcr do
  include ClientHelper

  let(:webhook) { client.webhook }

  let(:webhook_data) do
    CDEKApiClient::Entities::Webhook.new(
      url: 'https://yourapp.com/webhooks/cdek',
      type: 'ORDER_STATUS',
      event_types: %w[ORDER_STATUS DELIVERY_STATUS]
    )
  end

  describe '#register' do
    it 'registers a webhook successfully' do
      VCR.use_cassette('register_webhook') do
        response = webhook.register(webhook_data)
        expect(response).not_to include('error')
      end
    end

    it 'response includes uuid' do
      VCR.use_cassette('register_webhook') do
        response = webhook.register(webhook_data)
        expect(response['entity']).to include('uuid')
      end
    end
  end

  describe '#list' do
    it 'retrieves webhooks successfully' do
      VCR.use_cassette('get_webhooks') do
        response = webhook.list
        expect(response).not_to include('error')
      end
    end

    it 'response is an array' do
      VCR.use_cassette('get_webhooks') do
        response = webhook.list
        expect(response).to be_an(Array)
      end
    end
  end

  describe '#delete' do
    let(:webhook_id) do
      VCR.use_cassette('register_webhook') do
        response = webhook.register(webhook_data)
        response['entity']['uuid']
      end
    end

    it 'deletes a webhook successfully' do
      VCR.use_cassette('delete_webhook') do
        delete_response = webhook.delete(webhook_id)
        expect(delete_response).not_to include('error')
      end
    end

    it 'deletion is successful' do
      VCR.use_cassette('delete_webhook') do
        delete_response = webhook.delete(webhook_id)
        expect(delete_response['requests'].first['state']).to include('SUCCESSFUL')
      end
    end
  end
end

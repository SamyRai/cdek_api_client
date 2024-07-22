# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CDEKApiClient::Client, :vcr do
  include ClientHelper

  describe '#initialize' do
    it 'initializes order submodule correctly' do
      expect(client.order).to be_a(CDEKApiClient::API::Order)
    end

    it 'initializes location submodule correctly' do
      expect(client.location).to be_a(CDEKApiClient::API::Location)
    end

    it 'initializes tariff submodule correctly' do
      expect(client.tariff).to be_a(CDEKApiClient::API::Tariff)
    end

    it 'initializes webhook submodule correctly' do
      expect(client.webhook).to be_a(CDEKApiClient::API::Webhook)
    end
  end

  describe '#authenticate' do
    let(:token) { client.authenticate }

    context 'when authentication is successful' do
      before do
        VCR.use_cassette('authenticate') { token }
      end

      it 'retrieves an access token' do
        expect(token).not_to be_nil
      end

      it 'is a string' do
        expect(token).to be_a(String)
      end
    end

    context 'when authentication fails' do
      it 'raises an error' do
        response_double = instance_double(Net::HTTPResponse, is_a?: false, body: 'Error')
        allow(Net::HTTP).to receive(:post_form).and_return(response_double)
        expect { client.authenticate }.to raise_error(RuntimeError, 'Error getting token: Error')
      end
    end
  end
end

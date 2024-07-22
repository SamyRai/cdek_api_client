# frozen_string_literal: true

module CDEKApiClient
  class Webhook
    def initialize(client)
      @client = client
    end

    def register(webhook_data)
      response = @client.request('post', 'webhooks', body: webhook_data)
      @client.send(:handle_response, response)
    end

    def list
      response = @client.request('get', 'webhooks')
      @client.send(:handle_response, response)
    end

    def delete(webhook_id)
      response = @client.request('delete', "webhooks/#{webhook_id}")
      @client.send(:handle_response, response)
    end
  end
end

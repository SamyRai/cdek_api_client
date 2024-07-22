# frozen_string_literal: true

module CDEKApiClient
  # Handles webhook-related API requests.
  class Webhook
    # Initializes the Webhook object.
    #
    # @param client [CDEKApiClient::Client] the client instance.
    def initialize(client)
      @client = client
    end

    # Registers a new webhook.
    #
    # @param webhook_data [CDEKApiClient::Entities::Webhook] the data for the webhook.
    # @return [Hash] the response from the API.
    def register(webhook_data)
      response = @client.request('post', 'webhooks', body: webhook_data)
      @client.send(:handle_response, response)
    end

    # Retrieves a list of registered webhooks.
    #
    # @return [Array<Hash>] the list of webhooks.
    def list
      response = @client.request('get', 'webhooks')
      @client.send(:handle_response, response)
    end

    # Deletes a webhook by its ID.
    #
    # @param webhook_id [String] the ID of the webhook to delete.
    # @return [Hash] the response from the API.
    def delete(webhook_id)
      response = @client.request('delete', "webhooks/#{webhook_id}")
      @client.send(:handle_response, response)
    end
  end
end

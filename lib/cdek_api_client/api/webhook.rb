# frozen_string_literal: true

module CDEKApiClient
  module API
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

      # Registers a new webhook with simple parameters.
      #
      # @param url [String] the URL where the webhook will send data.
      # @param event_types [Array<String>] the list of event types for the webhook.
      # @param type [String] the type of webhook (default: 'WEBHOOK').
      # @return [Hash] the response from the API.
      def register_simple(url, event_types, type: 'WEBHOOK')
        webhook_data = CDEKApiClient::Entities::Webhook.new(
          url: url,
          type: type,
          event_types: event_types
        )
        register(webhook_data)
      end

      # Retrieves a list of registered webhooks.
      #
      # @return [Array<Hash>] the list of webhooks.
      def list
        response = @client.request('get', 'webhooks')
        @client.send(:handle_response, response)
      end

      # Retrieves a list of all registered webhooks.
      #
      # @return [Array<Hash>] the list of webhooks.
      def list_all
        response = @client.request('get', 'webhooks')
        @client.send(:handle_response, response)
      end

      # Retrieves information about a specific webhook by its UUID.
      #
      # @param webhook_uuid [String] the UUID of the webhook.
      # @return [Hash] the webhook information.
      def get(webhook_uuid)
        response = @client.request('get', "webhooks/#{webhook_uuid}")
        @client.send(:handle_response, response)
      end

      # Deletes a webhook by its UUID.
      #
      # @param webhook_uuid [String] the UUID of the webhook to delete.
      # @return [Hash] the response from the API.
      def delete(webhook_uuid)
        response = @client.request('delete', "webhooks/#{webhook_uuid}")
        @client.send(:handle_response, response)
      end
    end
  end
end

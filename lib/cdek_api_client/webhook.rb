# frozen_string_literal: true

module CDEKApiClient
  class Webhook
    BASE_URL = ENV.fetch('CDEK_API_URL', 'https://api.edu.cdek.ru/v2')
    WEBHOOKS_URL = "#{BASE_URL}/webhooks".freeze

    def initialize(client)
      @client = client
    end

    def register(webhook_data)
      validate_webhook_data(webhook_data)

      response = @client.auth_connection.post(WEBHOOKS_URL) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = webhook_data.to_json
      end
      handle_response(response)
    end

    def list
      response = @client.auth_connection.get(WEBHOOKS_URL) do |req|
        req.headers['Content-Type'] = 'application/json'
      end
      handle_response(response)
    end

    def delete(webhook_id)
      validate_uuid(webhook_id)

      response = @client.auth_connection.delete("#{WEBHOOKS_URL}/#{webhook_id}") do |req|
        req.headers['Content-Type'] = 'application/json'
      end
      handle_response(response)
    end

    private

    def validate_webhook_data(webhook_data)
      raise 'webhook_data must be a Webhook' unless webhook_data.is_a?(CDEKApiClient::Entities::Webhook)
    end

    def validate_uuid(uuid)
      return if uuid.match?(/\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}\z/)

      raise 'Invalid UUID format'
    end

    def handle_response(response)
      @client.send(:handle_response, response)
    end
  end
end

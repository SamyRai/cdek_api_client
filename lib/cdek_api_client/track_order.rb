# frozen_string_literal: true

module CDEKApiClient
  class TrackOrder
    BASE_URL = ENV.fetch('CDEK_API_URL', 'https://api.edu.cdek.ru/v2')
    TRACK_ORDER_URL = "#{BASE_URL}/orders/%<uuid>s".freeze

    def initialize(client)
      @client = client
    end

    def get(order_uuid)
      validate_uuid(order_uuid)

      response = @client.auth_connection.get(format(TRACK_ORDER_URL, uuid: order_uuid))
      handle_response(response)
    end

    private

    def validate_uuid(uuid)
      @client.send(:validate_uuid, uuid)
    end

    def handle_response(response)
      @client.send(:handle_response, response)
    end
  end
end

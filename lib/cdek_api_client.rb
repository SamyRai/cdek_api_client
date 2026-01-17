# frozen_string_literal: true

require_relative 'cdek_api_client/api/courier'
require_relative 'cdek_api_client/api/location'
require_relative 'cdek_api_client/api/order'
require_relative 'cdek_api_client/api/payment'
require_relative 'cdek_api_client/api/print'
require_relative 'cdek_api_client/api/tariff'
require_relative 'cdek_api_client/api/track_order'
require_relative 'cdek_api_client/api/webhook'
require_relative 'cdek_api_client/client'
require_relative 'cdek_api_client/entities/agreement'
require_relative 'cdek_api_client/entities/barcode'
require_relative 'cdek_api_client/entities/check'
require_relative 'cdek_api_client/entities/currency_mapper'
require_relative 'cdek_api_client/entities/intakes'
require_relative 'cdek_api_client/entities/invoice'
require_relative 'cdek_api_client/entities/item'
require_relative 'cdek_api_client/entities/location'
require_relative 'cdek_api_client/entities/order_data'
require_relative 'cdek_api_client/entities/package'
require_relative 'cdek_api_client/entities/payment'
require_relative 'cdek_api_client/entities/recipient'
require_relative 'cdek_api_client/entities/sender'
require_relative 'cdek_api_client/entities/service'
require_relative 'cdek_api_client/entities/tariff_data'
require_relative 'cdek_api_client/entities/validatable'
require_relative 'cdek_api_client/entities/webhook'
require_relative 'cdek_api_client/entities/auth_response'
require_relative 'cdek_api_client/entities/auth_error_response'
require_relative 'cdek_api_client/entities/intake_available_days_request'
require_relative 'cdek_api_client/entities/intake_available_days_response'
require_relative 'cdek_api_client/version'

# frozen_string_literal: true

# CDEKApiClient is a Ruby client for interacting with the CDEK API.
# It provides functionalities for order creation, tracking, tariff calculation,
# location data retrieval, and webhook management. This gem ensures clean,
# robust, and maintainable code with proper validations.
#
# To use this gem, configure it with your CDEK API client ID and secret,
# and then access various API functionalities through the provided client.
#
# Example:
#   CDEKApiClient.configure do |config|
#     config.client_id = 'your_client_id'
#     config.client_secret = 'your_client_secret'
#   end
#   client = CDEKApiClient.client
#
# For more details, refer to the README.
module CDEKApiClient
  class Error < StandardError; end

  class << self
    # Configures the client with the provided block.
    # @yield [self] Yields the client to the provided block.
    def configure
      yield self
    end

    # @!attribute [rw] client_id
    #   @return [String] The client ID for authentication.
    attr_accessor :client_id

    # @!attribute [rw] client_secret
    #   @return [String] The client secret for authentication.
    attr_accessor :client_secret
  end

  # Returns the CDEK API client.
  # @return [CDEKApiClient::Client] The CDEK API client instance.
  def self.client
    @client ||= CDEKApiClient::Client.new(client_id, client_secret)
  end
end

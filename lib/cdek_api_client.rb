# frozen_string_literal: true

require_relative 'cdek_api_client/api/location'
require_relative 'cdek_api_client/api/order'
require_relative 'cdek_api_client/api/tariff'
require_relative 'cdek_api_client/api/track_order'
require_relative 'cdek_api_client/api/webhook'
require_relative 'cdek_api_client/client'
require_relative 'cdek_api_client/entities/currency_mapper'
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
require_relative 'cdek_api_client/version'

module CDEKApiClient
  class Error < StandardError; end

  class << self
    def configure
      yield self
    end

    attr_accessor :client_id, :client_secret
  end

  def self.client
    @client ||= CDEKApiClient::Client.new(client_id, client_secret)
  end
end

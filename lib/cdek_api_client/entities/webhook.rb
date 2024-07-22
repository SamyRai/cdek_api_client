# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents a webhook entity in the CDEK API.
    # Each webhook includes attributes such as url, type, and event types.
    class Webhook
      include Validatable

      attr_accessor :url, :type, :event_types

      validates :url, type: :string, presence: true
      validates :type, type: :string, presence: true
      validates :event_types, type: :array, presence: true, items: [{ type: :string, presence: true }]

      # Initializes a new Webhook object.
      #
      # @param url [String] the URL where the webhook will send data.
      # @param type [String] the type of webhook.
      # @param event_types [Array<String>] the list of event types for the webhook.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(url:, type:, event_types:)
        @url = url
        @type = type
        @event_types = event_types
        validate!
      end

      # Converts the Webhook object to a JSON representation.
      #
      # @return [String] the JSON representation of the Webhook.
      def to_json(*_args)
        {
          url: @url,
          type: @type,
          event_types: @event_types
        }.to_json
      end
    end
  end
end

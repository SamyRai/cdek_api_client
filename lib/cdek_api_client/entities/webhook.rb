# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    class Webhook
      include Validatable

      attr_accessor :url, :type, :event_types

      validates :url, type: :string, presence: true
      validates :type, type: :string, presence: true
      validates :event_types, type: :array, presence: true, items: [{ type: :string, presence: true }]

      def initialize(url:, type:, event_types:)
        @url = url
        @type = type
        @event_types = event_types
        validate!
      end

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

# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents a sender entity in the CDEK API.
    # Each sender includes attributes such as name, phones, and email.
    class Sender
      include Validatable

      attr_accessor :name, :phones, :email

      validates :name, type: :string, presence: true
      validates :phones, type: :array, items: [{ type: :hash, schema: { number: { type: :string, presence: true } } }],
                         presence: true
      validates :email, type: :string, presence: true

      # Initializes a new Sender object.
      #
      # @param name [String] the name of the sender.
      # @param phones [Array<Hash>] the list of phone numbers for the sender.
      # @param email [String] the email address of the sender.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(name:, phones:, email:)
        @name = name
        @phones = phones
        @email = email
        validate!
      end

      # Converts the Sender object to a JSON representation.
      #
      # @return [String] the JSON representation of the Sender.
      def to_json(*_args)
        {
          name: @name,
          phones: @phones,
          email: @email
        }.to_json
      end
    end
  end
end

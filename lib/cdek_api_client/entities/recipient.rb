# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents a recipient entity in the CDEK API.
    # Each recipient includes attributes such as name, phones, and email.
    class Recipient
      include Validatable

      attr_accessor :name, :phones, :email

      validates :name, type: :string, presence: true
      validates :phones, type: :array, items: [{ type: :hash, schema: { number: { type: :string, presence: true } } }],
                         presence: true
      validates :email, type: :string, presence: true

      # Initializes a new Recipient object.
      #
      # @param name [String] the name of the recipient.
      # @param phones [Array<Hash>] the list of phone numbers for the recipient.
      # @param email [String] the email address of the recipient.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(name:, phones:, email:)
        @name = name
        @phones = phones
        @email = email
        validate!
      end

      # Converts the Recipient object to a JSON representation.
      #
      # @return [String] the JSON representation of the Recipient.
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

# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    class Sender
      include Validatable

      attr_accessor :name, :phones, :email

      validates :name, type: :string, presence: true
      validates :phones, type: :array, items: [{ type: :hash, schema: { number: { type: :string, presence: true } } }], presence: true
      validates :email, type: :string, presence: true

      def initialize(name:, phones:, email:)
        @name = name
        @phones = phones
        @email = email
        validate!
      end

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

# frozen_string_literal: true

module CDEKApiClient
  module Entities
    class Recipient
      attr_accessor :name, :phones, :email

      VALIDATION_RULES = {
        name: { type: :string, presence: true },
        phones: { type: :array, presence: true, items: [{ type: :string, presence: true }] },
        email: { type: :string, presence: true }
      }

      def initialize(name:, phones:, email:)
        @name = name
        @phones = phones
        @email = email

        Validator.validate(
          {
            name: @name,
            phones: @phones,
            email: @email
          }, VALIDATION_RULES
        )
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

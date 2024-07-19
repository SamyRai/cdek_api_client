# frozen_string_literal: true

require 'spec_helper'
require 'cdek_api_client/entities/validatable'

RSpec.describe CDEKApiClient::Entities::Validatable do
  describe '#validate!' do
    context 'with valid data' do
      it 'does not raise an error' do
        expect do
          Class.new do
            include CDEKApiClient::Entities::Validatable

            attr_accessor :name, :age, :emails

            validates :name, type: :string, presence: true
            validates :age, type: :integer, presence: true, positive: true
            validates :emails, type: :array, items: [{ type: :string, presence: true }]

            def initialize(name:, age:, emails:)
              @name = name
              @age = age
              @emails = emails
              validate!
            end
          end.new(name: 'John Doe', age: 30, emails: ['john@example.com'])
        end.not_to raise_error
      end
    end

    context 'with invalid data types' do
      it 'raises an error for invalid string type' do
        expect do
          Class.new do
            include CDEKApiClient::Entities::Validatable

            attr_accessor :name

            validates :name, type: :string, presence: true

            def initialize(name:)
              @name = name
              validate!
            end
          end.new(name: 123)
        end.to raise_error('name must be a String')
      end

      it 'raises an error for invalid integer type' do
        expect do
          Class.new do
            include CDEKApiClient::Entities::Validatable

            attr_accessor :age

            validates :age, type: :integer, presence: true

            def initialize(age:)
              @age = age
              validate!
            end
          end.new(age: 'abc')
        end.to raise_error('age must be an Integer')
      end

      it 'raises an error for negative integer' do
        expect do
          Class.new do
            include CDEKApiClient::Entities::Validatable

            attr_accessor :age

            validates :age, type: :integer, presence: true, positive: true

            def initialize(age:)
              @age = age
              validate!
            end
          end.new(age: -10)
        end.to raise_error('age must be a positive number')
      end
    end

    context 'with missing required attributes' do
      it 'raises an error for missing presence' do
        expect do
          Class.new do
            include CDEKApiClient::Entities::Validatable

            attr_accessor :name

            validates :name, type: :string, presence: true

            def initialize = validate!
          end.new
        end.to raise_error('name is required')
      end
    end

    context 'with nested invalid data types' do
      it 'raises an error for invalid nested string type' do
        expect do
          Class.new do
            include CDEKApiClient::Entities::Validatable

            attr_accessor :recipient

            validates :recipient, type: :object

            def initialize(recipient:)
              @recipient = recipient
              validate!
            end
          end.new(recipient: CDEKApiClient::Entities::Recipient.new(name: 123, phones: [{ number: '+123456789' }],
                                                                    email: 'test@test.com'))
        end.to raise_error('name must be a String')
      end

      it 'raises an error for missing nested required attribute' do
        expect do
          Class.new do
            include CDEKApiClient::Entities::Validatable

            attr_accessor :recipient

            validates :recipient, type: :object

            def initialize(recipient:)
              @recipient = recipient
              validate!
            end
          end.new(recipient: CDEKApiClient::Entities::Recipient.new(phones: [{ number: '+123456789' }],
                                                                    email: 'test@test.com'))
        end.to raise_error('missing keyword: :name')
      end
    end

    context 'with nested array invalid data types' do
      it 'raises an error for invalid nested array type' do
        expect do
          Class.new do
            include CDEKApiClient::Entities::Validatable

            attr_accessor :packages

            validates :packages, type: :array, items: [CDEKApiClient::Entities::Package]

            def initialize(packages:)
              @packages = packages
              validate!
            end
          end.new(packages: [CDEKApiClient::Entities::Package.new(number: 123, weight: 500, length: 50, width: 50,
                                                                  height: 50, items: [], comment: Faker::Lorem.sentence)])
        end.to raise_error('number must be a String')
      end
    end
  end
end

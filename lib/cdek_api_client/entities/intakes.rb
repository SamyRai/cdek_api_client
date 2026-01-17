# frozen_string_literal: true

require_relative 'validatable'

module CDEKApiClient
  module Entities
    # Represents an intakes entity for courier intake requests in the CDEK API.
    class Intakes
      include Validatable

      attr_accessor :cdek_number, :intake_date, :intake_time_from, :intake_time_to,
                    :lunch_time_from, :lunch_time_to, :name, :need_call, :comment,
                    :sender, :from_location, :weight, :length, :width, :height

      validates :cdek_number, type: :string, presence: true
      validates :intake_date, type: :string, presence: true
      validates :intake_time_from, type: :string, presence: true
      validates :intake_time_to, type: :string, presence: true
      validates :lunch_time_from, type: :string, presence: false
      validates :lunch_time_to, type: :string, presence: false
      validates :name, type: :string, presence: true
      validates :need_call, type: :boolean, presence: false
      validates :comment, type: :string, presence: false
      validates :sender, type: :hash, presence: true
      validates :from_location, type: :hash, presence: true
      validates :weight, type: :numeric, presence: false
      validates :length, type: :numeric, presence: false
      validates :width, type: :numeric, presence: false
      validates :height, type: :numeric, presence: false

      # Initializes a new Intakes object.
      #
      # @param cdek_number [String] the CDEK order number.
      # @param intake_date [String] the intake date in YYYY-MM-DD format.
      # @param intake_time_from [String] the start time in HH:MM format.
      # @param intake_time_to [String] the end time in HH:MM format.
      # @param lunch_time_from [String] the lunch start time in HH:MM format.
      # @param lunch_time_to [String] the lunch end time in HH:MM format.
      # @param name [String] the name/description of the cargo.
      # @param need_call [Boolean] whether a call is needed.
      # @param comment [String] the comment for the intake.
      # @param sender [Contact] the sender contact information.
      # @param from_location [Location] the pickup location.
      # @param weight [Numeric] the weight of the cargo.
      # @param length [Numeric] the length of the cargo.
      # @param width [Numeric] the width of the cargo.
      # @param height [Numeric] the height of the cargo.
      # @raise [ArgumentError] if any attribute validation fails.
      def initialize(cdek_number:, intake_date:, intake_time_from:, intake_time_to:,
                     name:, sender:, from_location:, lunch_time_from: nil, lunch_time_to: nil, need_call: nil,
                     comment: nil, weight: nil, length: nil,
                     width: nil, height: nil)
        @cdek_number = cdek_number
        @intake_date = intake_date
        @intake_time_from = intake_time_from
        @intake_time_to = intake_time_to
        @lunch_time_from = lunch_time_from
        @lunch_time_to = lunch_time_to
        @name = name
        @need_call = need_call
        @comment = comment
        @sender = sender
        @from_location = from_location
        @weight = weight
        @length = length
        @width = width
        @height = height
        validate!
      end

      # Converts the Intakes object to a JSON representation.
      #
      # @return [String] the JSON representation of the Intakes.
      def to_json(*_args)
        data = {
          cdek_number: @cdek_number,
          intake_date: @intake_date,
          intake_time_from: @intake_time_from,
          intake_time_to: @intake_time_to,
          name: @name,
          sender: @sender,
          from_location: @from_location
        }
        data[:lunch_time_from] = @lunch_time_from if @lunch_time_from
        data[:lunch_time_to] = @lunch_time_to if @lunch_time_to
        data[:need_call] = @need_call unless @need_call.nil?
        data[:comment] = @comment if @comment
        data[:weight] = @weight if @weight
        data[:length] = @length if @length
        data[:width] = @width if @width
        data[:height] = @height if @height
        data.to_json
      end
    end
  end
end

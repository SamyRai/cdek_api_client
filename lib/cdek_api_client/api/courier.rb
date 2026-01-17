# frozen_string_literal: true

module CDEKApiClient
  module API
    # Handles courier-related API requests (agreements and intakes).
    class Courier
      # Initializes the Courier object.
      #
      # @param client [CDEKApiClient::Client] the client instance.
      def initialize(client)
        @client = client
      end

      # Creates a delivery agreement.
      #
      # @param agreement_data [CDEKApiClient::Entities::Agreement] the agreement data.
      # @return [Hash] the response from the API.
      def create_agreement(agreement_data)
        response = @client.request('post', 'delivery', body: agreement_data)
        handle_response(response)
      end

      # Gets agreement information by UUID.
      #
      # @param agreement_uuid [String] the UUID of the agreement.
      # @return [Hash] the agreement information.
      def get_agreement(agreement_uuid)
        validate_uuid(agreement_uuid)
        response = @client.request('get', "delivery/#{agreement_uuid}")
        handle_response(response)
      end

      # Creates a courier intake request.
      #
      # @param intake_data [CDEKApiClient::Entities::Intakes] the intake data.
      # @return [Hash] the response from the API.
      def create_intake(intake_data)
        response = @client.request('post', 'intakes', body: intake_data)
        handle_response(response)
      end

      # Gets intake information by UUID.
      #
      # @param intake_uuid [String] the UUID of the intake.
      # @return [Hash] the intake information.
      def get_intake(intake_uuid)
        validate_uuid(intake_uuid)
        response = @client.request('get', "intakes/#{intake_uuid}")
        handle_response(response)
      end

      # Deletes an intake request by UUID.
      #
      # @param intake_uuid [String] the UUID of the intake to delete.
      # @return [Hash] the response from the API.
      def delete_intake(intake_uuid)
        validate_uuid(intake_uuid)
        response = @client.request('delete', "intakes/#{intake_uuid}")
        handle_response(response)
      end

      # Gets available days for courier intake.
      #
      # @param request_data [CDEKApiClient::Entities::IntakeAvailableDaysRequest] the request data.
      # @return [Hash] the available days information.
      def create_intake_available_days(request_data)
        response = @client.request('post', 'intakes/availableDays', body: request_data)
        handle_response(response)
      end

      # Gets available delivery intervals for an order.
      #
      # @param cdek_number [String, nil] the CDEK order number.
      # @param order_uuid [String, nil] the order UUID.
      # @return [Hash] the available delivery intervals.
      def get_delivery_intervals(cdek_number: nil, order_uuid: nil)
        query = {}
        query[:cdek_number] = cdek_number if cdek_number
        query[:order_uuid] = order_uuid if order_uuid

        response = @client.request('get', 'delivery/intervals', query: query)
        handle_response(response)
      end

      private

      # Validates UUID format.
      #
      # @param uuid [String] the UUID to validate.
      # @raise [ArgumentError] if the UUID format is invalid.
      def validate_uuid(uuid)
        @client.validate_uuid(uuid)
      end

      # Handles the response from the API.
      #
      # @param response [Net::HTTPResponse] the response from the API.
      # @return [Hash] the parsed response.
      def handle_response(response)
        @client.send(:handle_response, response)
      end
    end
  end
end

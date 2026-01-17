# frozen_string_literal: true

module CDEKApiClient
  module API
    # Handles print-related API requests (barcodes and invoices).
    class Print
      # Initializes the Print object.
      #
      # @param client [CDEKApiClient::Client] the client instance.
      def initialize(client)
        @client = client
      end

      # Creates a barcode for an order.
      #
      # @param barcode_data [CDEKApiClient::Entities::Barcode] the barcode data.
      # @return [Hash] the response from the API.
      def create_barcode(barcode_data)
        response = @client.request('post', 'print/barcodes', body: barcode_data)
        handle_response(response)
      end

      # Gets barcode information by UUID.
      #
      # @param barcode_uuid [String] the UUID of the barcode.
      # @return [Hash] the barcode information.
      def get_barcode(barcode_uuid)
        response = @client.request('get', "print/barcodes/#{barcode_uuid}")
        handle_response(response)
      end

      # Gets barcode PDF by UUID.
      #
      # @param barcode_uuid [String] the UUID of the barcode.
      # @return [String] the PDF content.
      def get_barcode_pdf(barcode_uuid)
        response = @client.request('get', "print/barcodes/#{barcode_uuid}.pdf")
        handle_binary_response(response)
      end

      # Creates an invoice for an order.
      #
      # @param invoice_data [CDEKApiClient::Entities::Invoice] the invoice data.
      # @return [Hash] the response from the API.
      def create_invoice(invoice_data)
        response = @client.request('post', 'print/orders', body: invoice_data)
        handle_response(response)
      end

      # Gets invoice information by UUID.
      #
      # @param invoice_uuid [String] the UUID of the invoice.
      # @return [Hash] the invoice information.
      def get_invoice(invoice_uuid)
        response = @client.request('get', "print/orders/#{invoice_uuid}")
        handle_response(response)
      end

      # Gets invoice PDF by UUID.
      #
      # @param invoice_uuid [String] the UUID of the invoice.
      # @return [String] the PDF content.
      def get_invoice_pdf(invoice_uuid)
        response = @client.request('get', "print/orders/#{invoice_uuid}.pdf")
        handle_binary_response(response)
      end

      private

      # Handles the response from the API.
      #
      # @param response [Net::HTTPResponse] the response from the API.
      # @return [Hash] the parsed response.
      def handle_response(response)
        @client.send(:handle_response, response)
      end

      # Handles binary responses (PDF files).
      #
      # @param response [Net::HTTPResponse] the response from the API.
      # @return [String] the binary content.
      def handle_binary_response(response)
        case response
        when Net::HTTPSuccess
          response.body
        else
          handle_response(response)
        end
      end
    end
  end
end

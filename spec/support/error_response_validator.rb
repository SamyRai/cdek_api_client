# frozen_string_literal: true

require_relative 'schema_validator'

# ErrorResponseValidator provides comprehensive testing for API error responses
# Validates error formats against schema definitions for different status codes
class ErrorResponseValidator
  class << self
    # Test error response for a specific endpoint and status code
    def test_error_response(path, method = 'post', status_code = 400, error_data = nil)
      schema = SchemaLoader.load_response_schema(path, method, status_code)
      return { valid: false, errors: ['Error schema not found'] } unless schema

      # Generate mock error data if not provided
      error_data ||= generate_mock_error_data(schema, status_code)

      validate_error_data(error_data, schema, path)
    end

    # Validate error data against error schema
    def validate_error_data(error_data, schema, context_path = nil)
      SchemaValidator.validate_data_against_schema(error_data, schema, context_path)
    end

    # Generate mock error data based on schema and status code
    def generate_mock_error_data(schema, status_code)
      case status_code
      when 400
        generate_bad_request_error(schema)
      when 401
        generate_unauthorized_error(schema)
      when 403
        generate_forbidden_error(schema)
      when 404
        generate_not_found_error(schema)
      when 422
        generate_validation_error(schema)
      when 429
        generate_rate_limit_error(schema)
      when 500
        generate_server_error(schema)
      else
        generate_generic_error(schema, status_code)
      end
    end

    # Generate different types of error responses
    def generate_bad_request_error(_schema)
      {
        'error' => 'Bad Request',
        'error_description' => 'Invalid request parameters',
        'errors' => [
          {
            'field' => 'cdek_number',
            'message' => 'CDEK number is required'
          }
        ]
      }
    end

    def generate_unauthorized_error(_schema)
      {
        'error' => 'unauthorized',
        'error_description' => 'Invalid or expired access token'
      }
    end

    def generate_forbidden_error(_schema)
      {
        'error' => 'insufficient_scope',
        'error_description' => 'The request requires higher privileges'
      }
    end

    def generate_not_found_error(_schema)
      {
        'error' => 'Not Found',
        'error_description' => 'The requested resource was not found',
        'code' => 404
      }
    end

    def generate_validation_error(_schema)
      {
        'error' => 'Validation Error',
        'error_description' => 'Request data failed validation',
        'validation_errors' => [
          {
            'field' => 'from_location.code',
            'message' => 'Location code must be a valid integer'
          }
        ]
      }
    end

    def generate_rate_limit_error(_schema)
      {
        'error' => 'rate_limit_exceeded',
        'error_description' => 'Too many requests',
        'retry_after' => 60
      }
    end

    def generate_server_error(_schema)
      {
        'error' => 'Internal Server Error',
        'error_description' => 'An unexpected error occurred',
        'request_id' => 'req_123456789'
      }
    end

    def generate_generic_error(_schema, status_code)
      {
        'error' => 'Error',
        'error_description' => "HTTP #{status_code} error occurred",
        'status_code' => status_code
      }
    end

    # Test all common error status codes for an endpoint
    def test_all_error_codes(path, method = 'post')
      error_codes = [400, 401, 403, 404, 422, 429, 500]
      results = {}

      error_codes.each do |code|
        result = test_error_response(path, method, code)
        results[code] = result
      end

      results
    end

    # Generate comprehensive error test cases
    def generate_error_test_cases
      test_cases = []

      # Define endpoints and their expected error codes
      endpoints = {
        '/v2/orders' => ['post'],
        '/v2/orders/{uuid}' => %w[get patch delete],
        '/v2/calculator/tariff' => ['post'],
        '/v2/delivery' => ['post'],
        '/v2/deliverypoints' => ['get'],
        '/v2/webhooks' => ['post'],
        '/v2/intakes' => ['post']
      }

      endpoints.each do |path, methods|
        methods.each do |method|
          # Test common error codes for each endpoint
          [400, 401, 404, 422].each do |status_code|
            test_cases << {
              path: path,
              method: method,
              status_code: status_code,
              description: "#{method.upcase} #{path} - #{status_code} error"
            }
          end
        end
      end

      test_cases
    end
  end
end

# frozen_string_literal: true

require 'json_schemer'
require_relative 'schema_loader'

# SchemaValidator validates data against JSON schemas using json_schemer
class SchemaValidator
  class << self
    # Validate request data against endpoint schema
    def validate_request(path, method = 'post', data)
      schema = SchemaLoader.load_request_schema(path, method)
      return { valid: false, errors: ['Schema not found'] } unless schema

      validate_data_against_schema(data, schema, path)
    end

    # Validate response data against endpoint schema
    def validate_response(path, method = 'post', status_code = 200, data)
      schema = SchemaLoader.load_response_schema(path, method, status_code)
      return { valid: false, errors: ['Schema not found'] } unless schema

      validate_data_against_schema(data, schema, path)
    end

    # Validate data against a schema with enhanced JSON Schema validation
    def validate_data_against_schema(data, schema, context_path = nil)
      errors = []

      begin
        # Try full JSON Schema validation first
        json_schema_result = validate_with_json_schema(data, schema, context_path)
        return json_schema_result if json_schema_result

        # Fall back to basic structural validation
        validate_basic_structure(data, schema, errors, '')

        {
          valid: errors.empty?,
          errors: errors
        }
      rescue StandardError => e
        {
          valid: false,
          errors: ["Validation setup error: #{e.message}"]
        }
      end
    end

    # Attempt full JSON Schema validation with proper reference resolution
    def validate_with_json_schema(data, schema, context_path)
      return nil unless defined?(JSONSchemer)

      begin
        # Get the full schema context for reference resolution
        context_schema = SchemaLoader.find_context_schema_for_endpoint(context_path) if context_path

        if context_schema
          # Create schema with full context for $ref resolution
          schemer = JSONSchemer.schema(context_schema)

          # Validate against the specific subschema by finding it in the context
          validation_errors = []
          schemer.validate(data).each do |error|
            # Filter errors to be relevant to our data structure
            validation_errors << format_json_schema_error(error) if is_relevant_error?(error, schema, data)
          end

          return {
            valid: validation_errors.empty?,
            errors: validation_errors
          }
        end

        # If no context schema, try direct validation with the subschema
        schemer = JSONSchemer.schema(schema)
        validation_errors = []
        schemer.validate(data).each do |error|
          validation_errors << format_json_schema_error(error)
        end

        {
          valid: validation_errors.empty?,
          errors: validation_errors
        }
      rescue StandardError
        # Return nil to fall back to basic validation
        nil
      end
    end

    # Check if a JSON Schema error is relevant to our data
    def is_relevant_error?(error, schema, _data)
      error_type = error['type']
      return true if %w[required type minimum maximum minLength maxLength].include?(error_type)

      # For object validation, check if the path exists in our schema
      if error_type == 'schema' && schema['type'] == 'object'
        data_pointer = error.get('data_pointer', '')
        property = data_pointer.split('/').last if data_pointer
        return schema['properties']&.key?(property) if property
      end

      true # Include error by default
    end

    # Format JSON Schema errors into readable messages
    def format_json_schema_error(error)
      error_type = error['type']
      data_pointer = error['data_pointer'] || ''
      schema_info = error['schema']
      data_value = error['data']

      case error_type
      when 'required'
        "Missing required field: #{error['details']&.fetch('missing_key', 'unknown')}"
      when 'type'
        expected_type = schema_info['type'] if schema_info.is_a?(Hash)
        "Type mismatch at #{data_pointer}: expected #{expected_type}, got #{data_value.class.name}"
      when 'minimum', 'maximum'
        limit_type = error_type
        limit_value = schema_info[limit_type] if schema_info.is_a?(Hash)
        "Value #{data_value} is #{limit_type == 'minimum' ? 'below' : 'above'} #{limit_type} limit of #{limit_value}"
      when 'minLength', 'maxLength'
        length_type = error_type.sub('Length', '').downcase
        length_limit = schema_info[error_type] if schema_info.is_a?(Hash)
        "String length #{data_value&.length || 0} is #{length_type} than #{length_type == 'min' ? 'minimum' : 'maximum'} of #{length_limit}"
      when 'pattern'
        'String does not match required pattern'
      when 'enum'
        "Value #{data_value} is not in allowed values"
      else
        "Schema validation error: #{error_type} at #{data_pointer}"
      end
    end

    private

    def validate_basic_structure(data, schema, errors, path)
      resolved_schema = schema['$ref'] ? SchemaLoader.resolve_schema_reference(schema) : schema

      case resolved_schema['type']
      when 'object'
        validate_object_structure(data, resolved_schema, errors, path)
      when 'array'
        validate_array_structure(data, resolved_schema, errors, path)
      when 'string'
        validate_string_value(data, resolved_schema, errors, path)
      when 'integer'
        validate_integer_value(data, resolved_schema, errors, path)
      when 'number'
        validate_number_value(data, resolved_schema, errors, path)
      when 'boolean'
        validate_boolean_value(data, resolved_schema, errors, path)
      end
    end

    def validate_object_structure(data, schema, errors, path)
      return unless data.is_a?(Hash)

      # Check required fields
      required = schema['required'] || []
      required.each do |field|
        unless data.key?(field)
          errors << ("Missing required field: #{field}" + (path.empty? ? '' : " at #{path}"))
        end
      end

      # Validate each property
      return unless schema['properties']

      schema['properties'].each do |prop_name, prop_schema|
        validate_basic_structure(data[prop_name], prop_schema, errors, "#{path}.#{prop_name}") if data.key?(prop_name)
      end
    end

    def validate_array_structure(data, schema, errors, path)
      return unless data.is_a?(Array)

      # Check minimum items
      if schema['minItems'] && data.size < schema['minItems']
        errors << "Array must have at least #{schema['minItems']} items at #{path}"
      end

      # Validate each item
      return unless schema['items']

      data.each_with_index do |item, index|
        validate_basic_structure(item, schema['items'], errors, "#{path}[#{index}]")
      end
    end

    def validate_string_value(data, schema, errors, path)
      unless data.is_a?(String)
        errors << "Expected string at #{path}, got #{data.class.name}"
        return
      end

      # Check minLength
      if schema['minLength'] && data.length < schema['minLength']
        errors << "String too short at #{path}: #{data.length} < #{schema['minLength']}"
      end

      # Check maxLength
      if schema['maxLength'] && data.length > schema['maxLength']
        errors << "String too long at #{path}: #{data.length} > #{schema['maxLength']}"
      end

      # Check pattern (basic check)
      if schema['pattern'] && !data.match?(Regexp.new(schema['pattern']))
        errors << "String does not match pattern at #{path}"
      end

      # Check enum
      return unless schema['enum'] && !schema['enum'].include?(data)

      errors << "String not in allowed values at #{path}: #{data}"
    end

    def validate_integer_value(data, schema, errors, path)
      unless data.is_a?(Integer)
        errors << "Expected integer at #{path}, got #{data.class.name}"
        return
      end

      # Check minimum
      if schema['minimum'] && data < schema['minimum']
        errors << "Integer too small at #{path}: #{data} < #{schema['minimum']}"
      end

      # Check maximum
      return unless schema['maximum'] && data > schema['maximum']

      errors << "Integer too large at #{path}: #{data} > #{schema['maximum']}"
    end

    def validate_number_value(data, schema, errors, path)
      unless data.is_a?(Numeric)
        errors << "Expected number at #{path}, got #{data.class.name}"
        return
      end

      # Similar to integer but allows floats
      if schema['minimum'] && data < schema['minimum']
        errors << "Number too small at #{path}: #{data} < #{schema['minimum']}"
      end

      return unless schema['maximum'] && data > schema['maximum']

      errors << "Number too large at #{path}: #{data} > #{schema['maximum']}"
    end

    def validate_boolean_value(data, _schema, errors, path)
      return if [true, false].include?(data)

      errors << "Expected boolean at #{path}, got #{data.class.name}"
    end

    # Convenience method for RSpec assertions
    def valid_request?(path, method = 'post', data)
      result = validate_request(path, method, data)
      result[:valid]
    end

    # Convenience method for RSpec assertions
    def valid_response?(path, method = 'post', status_code = 200, data)
      result = validate_response(path, method, status_code, data)
      result[:valid]
    end

    # Get validation errors for a request
    def request_errors(path, method = 'post', data)
      result = validate_request(path, method, data)
      result[:errors]
    end

    # Get validation errors for a response
    def response_errors(path, method = 'post', status_code = 200, data)
      result = validate_response(path, method, status_code, data)
      result[:errors]
    end

    def format_validation_error(error)
      case error['type']
      when 'required'
        "Missing required field: #{error['details']&.fetch('missing_key', 'unknown')}"
      when 'schema'
        "Schema validation error: #{error['details']&.fetch('error', 'unknown error')}"
      when 'pattern'
        "Pattern mismatch for field '#{error['data_pointer']&.split('/')&.last}': #{error['details']&.fetch('pattern',
                                                                                                            'unknown pattern')}"
      when 'minimum', 'maximum'
        "Value #{error['data']} is #{error['type']} than allowed (#{error['schema'][error['type']]}) for field '#{error['data_pointer']&.split('/')&.last}'"
      when 'minLength', 'maxLength'
        "String length #{error['data']&.length || 0} is #{error['type'].sub('Length',
                                                                            '').downcase} than allowed (#{error['schema'][error['type']]}) for field '#{error['data_pointer']&.split('/')&.last}'"
      when 'type'
        "Type mismatch for field '#{error['data_pointer']&.split('/')&.last}': expected #{error['schema']['type']}, got #{error['data'].class.name.downcase}"
      else
        "Validation error: #{error['type']} - #{error['details']&.to_json || 'unknown details'}"
      end
    end
  end
end

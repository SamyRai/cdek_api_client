# frozen_string_literal: true

require_relative 'schema_driven_generator'

# EdgeCaseGenerator creates invalid test data that violates schema constraints
# Useful for testing error handling and validation
class EdgeCaseGenerator
  class << self
    # Generate edge cases for an endpoint
    def generate_edge_cases(path, method = 'post')
      schema = SchemaLoader.load_request_schema(path, method)
      return [] unless schema

      edge_cases = []

      # Generate various types of invalid data
      edge_cases.concat(generate_missing_required_fields(schema))
      edge_cases.concat(generate_wrong_types(schema))
      edge_cases.concat(generate_out_of_range_values(schema))
      edge_cases.concat(generate_invalid_strings(schema))
      edge_cases.concat(generate_invalid_enums(schema))

      edge_cases.uniq(&:to_json) # Remove duplicates
    end

    # Generate data with missing required fields
    def generate_missing_required_fields(schema)
      return [] unless schema['properties']

      required = schema['required'] || []
      return [] if required.empty?

      edge_cases = []

      # Try removing each required field
      required.each do |field|
        valid_data = SchemaDrivenGenerator.generate_from_schema(schema)
        next unless valid_data.is_a?(Hash) && valid_data.key?(field)

        invalid_data = valid_data.dup
        invalid_data.delete(field)
        edge_cases << invalid_data
      end

      edge_cases
    end

    # Generate data with wrong types
    def generate_wrong_types(schema)
      return [] unless schema['properties']

      edge_cases = []

      schema['properties'].each do |field_name, field_schema|
        next unless field_schema

        valid_data = SchemaDrivenGenerator.generate_from_schema(schema)
        next unless valid_data.is_a?(Hash) && valid_data.key?(field_name)

        invalid_data = valid_data.dup

        # Change type based on expected type
        case field_schema['type']
        when 'string'
          invalid_data[field_name] = 12_345 # Number instead of string
        when 'integer'
          invalid_data[field_name] = 'not_a_number' # String instead of integer
        when 'number'
          invalid_data[field_name] = 'not_a_number' # String instead of number
        when 'boolean'
          invalid_data[field_name] = 'not_boolean' # String instead of boolean
        when 'object'
          invalid_data[field_name] = 'not_an_object' # String instead of object
        when 'array'
          invalid_data[field_name] = 'not_an_array' # String instead of array
        end

        edge_cases << invalid_data
      end

      edge_cases
    end

    # Generate data with out-of-range values
    def generate_out_of_range_values(schema)
      return [] unless schema['properties']

      edge_cases = []

      schema['properties'].each do |field_name, field_schema|
        next unless field_schema

        valid_data = SchemaDrivenGenerator.generate_from_schema(schema)
        next unless valid_data.is_a?(Hash)

        invalid_data = valid_data.dup

        case field_schema['type']
        when 'integer', 'number'
          if field_schema['minimum']
            invalid_data[field_name] = field_schema['minimum'] - 1
            edge_cases << invalid_data.dup
          end
          if field_schema['maximum']
            invalid_data[field_name] = field_schema['maximum'] + 1
            edge_cases << invalid_data.dup
          end
        when 'string'
          if field_schema['minLength']
            invalid_data[field_name] = 'a' * (field_schema['minLength'] - 1)
            edge_cases << invalid_data.dup
          end
          if field_schema['maxLength']
            invalid_data[field_name] = 'a' * (field_schema['maxLength'] + 1)
            edge_cases << invalid_data.dup
          end
        when 'array'
          if field_schema['minItems']
            invalid_data[field_name] = [] # Empty array when minItems > 0
            edge_cases << invalid_data.dup
          end
        end
      end

      edge_cases
    end

    # Generate invalid strings (wrong patterns, etc.)
    def generate_invalid_strings(schema)
      return [] unless schema['properties']

      edge_cases = []

      schema['properties'].each do |field_name, field_schema|
        next unless field_schema && field_schema['type'] == 'string'

        valid_data = SchemaDrivenGenerator.generate_from_schema(schema)
        next unless valid_data.is_a?(Hash)

        invalid_data = valid_data.dup

        # Generate strings that don't match patterns
        next unless field_schema['pattern']

        invalid_data[field_name] = case field_schema['pattern']
                                   when /^\d+$/ # Digits only
                                     'not_digits_only'
                                   when /^[\w.-]+@[\w.-]+\.\w+$/ # Email pattern
                                     'not_an_email'
                                   when /^\+?\d{10,15}$/ # Phone pattern
                                     'not_a_phone'
                                   else
                                     'invalid_pattern_string'
                                   end
        edge_cases << invalid_data
      end

      edge_cases
    end

    # Generate invalid enum values
    def generate_invalid_enums(schema)
      return [] unless schema['properties']

      edge_cases = []

      schema['properties'].each do |field_name, field_schema|
        next unless field_schema && field_schema['enum']

        valid_data = SchemaDrivenGenerator.generate_from_schema(schema)
        next unless valid_data.is_a?(Hash)

        invalid_data = valid_data.dup
        invalid_data[field_name] = 'invalid_enum_value_not_in_list'
        edge_cases << invalid_data
      end

      edge_cases
    end

    # Generate a single random edge case
    def generate_random_edge_case(path, method = 'post')
      edge_cases = generate_edge_cases(path, method)
      edge_cases.sample
    end
  end
end

# frozen_string_literal: true

# PerformanceValidator provides performance testing and validation
# Measures response times, payload sizes, and system performance
class PerformanceValidator
  class << self
    # Performance thresholds (in milliseconds)
    PERFORMANCE_THRESHOLDS = {
      fast: 100,      # Fast operations
      normal: 500,    # Normal operations
      slow: 2000,     # Slow operations (acceptable)
      timeout: 10_000 # Maximum acceptable time
    }.freeze

    # Measure execution time of a block
    def measure_execution_time(&block)
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      result = block.call
      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      execution_time_ms = (end_time - start_time) * 1000

      {
        result: result,
        execution_time_ms: execution_time_ms,
        performance_rating: rate_performance(execution_time_ms)
      }
    end

    # Rate performance based on execution time
    def rate_performance(execution_time_ms)
      case execution_time_ms
      when 0..PERFORMANCE_THRESHOLDS[:fast]
        :excellent
      when 0..PERFORMANCE_THRESHOLDS[:normal]
        :good
      when 0..PERFORMANCE_THRESHOLDS[:slow]
        :acceptable
      when 0..PERFORMANCE_THRESHOLDS[:timeout]
        :slow
      else
        :unacceptable
      end
    end

    # Validate payload size constraints
    def validate_payload_size(data, max_size_kb = 1000)
      size_bytes = calculate_data_size(data)
      size_kb = size_bytes / 1024.0

      {
        size_bytes: size_bytes,
        size_kb: size_kb,
        within_limit: size_kb <= max_size_kb,
        max_size_kb: max_size_kb
      }
    end

    # Calculate data size in bytes
    def calculate_data_size(data)
      case data
      when String
        data.bytesize
      when Hash, Array
        data.to_json.bytesize
      else
        data.to_s.bytesize
      end
    end

    # Test pagination handling
    def test_pagination_support(endpoint_path, base_params = {})
      pagination_scenarios = [
        { size: 10, page: 1 },
        { size: 50, page: 1 },
        { size: 100, page: 2 },
        { size: 500, page: 1 } # Large page size
      ]

      results = {}

      pagination_scenarios.each do |scenario|
        params = base_params.merge(scenario)
        results[scenario] = measure_execution_time do
          # This would normally make an API call
          # For testing, we'll simulate pagination
          simulate_pagination_request(endpoint_path, params)
        end
      end

      results
    end

    # Test large payload handling
    def test_large_payload_handling(endpoint_path, method = 'post')
      payload_sizes = [1, 10, 50, 100, 500] # KB

      results = {}

      payload_sizes.each do |size_kb|
        large_payload = generate_large_payload(size_kb)

        results[size_kb] = measure_execution_time do
          # This would normally make an API call with large payload
          simulate_large_payload_request(endpoint_path, method, large_payload)
        end.merge(validate_payload_size(large_payload, 1000))
      end

      results
    end

    # Generate a large test payload
    def generate_large_payload(size_kb)
      # Create a payload of approximately the target size
      target_bytes = size_kb * 1024
      base_item = {
        number: 'PKG001',
        weight: 1000,
        length: 10,
        width: 10,
        height: 10,
        items: [{
          name: 'Test Item',
          ware_key: 'TEST123',
          payment: { value: 100, currency: 'RUB' },
          cost: 100,
          weight: 500,
          amount: 1
        }]
      }

      # Estimate item size and calculate how many to create
      item_size = base_item.to_json.bytesize
      item_count = (target_bytes / item_size).to_i

      {
        tariff_code: 139,
        from_location: { code: 44, city: 'Moscow', address: 'Test Address' },
        to_location: { code: 75, city: 'Saint Petersburg', address: 'Test Address' },
        packages: [base_item] * [item_count, 1].max, # At least 1 item
        comment: 'Large payload test'
      }
    end

    # Test concurrent request handling
    def test_concurrent_performance(_endpoint_path, concurrent_requests = 5, &request_block)
      return {} unless block_given?

      threads = []
      results = []

      concurrent_requests.times do
        threads << Thread.new do
          result = measure_execution_time(&request_block)
          results << result
        end
      end

      threads.each(&:join)

      # Analyze concurrent performance
      execution_times = results.map { |r| r[:execution_time_ms] }
      avg_time = execution_times.sum / execution_times.size
      max_time = execution_times.max
      min_time = execution_times.min

      {
        concurrent_requests: concurrent_requests,
        individual_results: results,
        summary: {
          avg_execution_time_ms: avg_time,
          max_execution_time_ms: max_time,
          min_execution_time_ms: min_time,
          performance_rating: rate_performance(avg_time)
        }
      }
    end

    private

    # Simulate pagination request (for testing without real API)
    def simulate_pagination_request(_endpoint_path, params)
      # Simulate processing time based on page size
      size = params[:size] || 10
      sleep_time = [size / 1000.0, 0.001].max # Simulate processing
      sleep(sleep_time)

      {
        items: Array.new([size, 100].min) { |i| { id: i + 1, name: "Item #{i + 1}" } },
        total: 1000,
        page: params[:page] || 1,
        size: size
      }
    end

    # Simulate large payload request (for testing without real API)
    def simulate_large_payload_request(_endpoint_path, _method, payload)
      # Simulate processing time based on payload size
      size_kb = calculate_data_size(payload) / 1024.0
      sleep_time = [size_kb / 100.0, 0.001].max # Simulate processing
      sleep(sleep_time)

      { success: true, processed_kb: size_kb }
    end
  end
end

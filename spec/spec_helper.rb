# frozen_string_literal: true

require 'vcr'
require 'webmock/rspec'
require 'faker'
require 'pry'
require_relative '../lib/cdek_api_client' # Ensure this line is added

Faker::Config.locale = 'ru'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  # reduce log output
  # config.debug_logger = $stderr # Added this line here
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = { record: :new_episodes }
end

RSpec.configure do |config|
  config.before(:suite) do
    $logger = Logger.new($stdout)
    $logger.level = Logger::DEBUG
  end

  config.before do
    stub_request(:post, 'https://api.cdek.ru/v2/oauth/token').to_return(
      status: 200,
      body: { access_token: 'test_token' }.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end

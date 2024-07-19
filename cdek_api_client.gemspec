# frozen_string_literal: true

require_relative 'lib/cdek_api_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'cdek_api_client'
  spec.version       = CDEKApiClient::VERSION
  spec.authors       = ['Damir Mukimov']
  spec.email         = ['mukimov.d@gmail.com']

  spec.summary       = 'A Ruby client for the CDEK API'
  spec.description   = 'This gem provides a Ruby client for interacting with the CDEK API, including order creation, tracking, and tariff calculation.'
  spec.homepage      = 'http://glowing-pixels.com/cdek_api_client'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday'
  spec.add_dependency 'base64'
  spec.add_dependency 'faraday_middleware'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'http://gihub.com/glowing-pixels/cdek_api_client'
  spec.metadata['changelog_uri'] = 'http://www.glowing-pixels.com/cdek_api_client/CHANGELOG.md'
end

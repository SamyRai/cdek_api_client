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

  spec.required_ruby_version = '>= 3.0'

  spec.metadata['github_repo'] = 'git@github.com/SamyRai/cdek_api_client.git'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'http://github.com/SamyRai/cdek_api_client'
  spec.metadata['changelog_uri'] = 'https://github.com/SamyRai/cdek_api_client?tab=readme-ov-file#changelog'
  spec.metadata['rubygems_mfa_required'] = 'true'
end

# frozen_string_literal: true

module CDEKApiClient
  # Configuration module for CDEK API Client
  module Config
    # Available API environments
    PRODUCTION = 'production'
    DEMO = 'demo'

    # API endpoints for different environments
    ENDPOINTS = {
      PRODUCTION => 'https://api.cdek.ru/v2',
      DEMO => 'https://api.edu.cdek.ru/v2'
    }.freeze

    class << self
      # Get the base URL for the current configuration
      # @param environment [String, Symbol] The environment (:production, :demo, 'production', 'demo')
      # @param custom_url [String] Custom API URL (overrides environment)
      # @return [String] The base API URL
      def base_url(environment: nil, custom_url: nil)
        return custom_url if custom_url

        env = environment&.to_s&.downcase || ENV.fetch('CDEK_API_ENV', DEMO)
        ENDPOINTS.fetch(env) do
          raise ArgumentError, "Unknown environment: #{env}. Use :production or :demo"
        end
      end

      # Get the token URL for authentication
      # @param environment [String, Symbol] The environment
      # @param custom_url [String] Custom API URL
      # @return [String] The OAuth token URL
      def token_url(environment: nil, custom_url: nil)
        "#{base_url(environment: environment, custom_url: custom_url)}/oauth/token"
      end
    end
  end
end

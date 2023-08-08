# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "faraday/typhoeus"
require "roseflow/types"
require "roseflow/stabilityai/config"
require "roseflow/stabilityai/model"

module Roseflow
  module StabilityAI
    class Client
      FARADAY_RETRY_OPTIONS = {
        max: 3,
        interval: 0.05,
        interval_randomness: 0.5,
        backoff_factor: 2,
      }

      def initialize(config = Config.new, provider = nil)
        @config = config
        @provider = provider
      end

      def models
        response = connection.get("/v1/engines/list")
        body = JSON.parse(response.body)
      end

      def post(operation)
        response = connection.post(operation.path) do |request|
          request.body = operation.body
        end
        response
      end

      private

      attr_reader :config, :provider

      def connection
        @connection ||= Faraday.new(
          url: config.api_url,
          headers: {
            "Stability-Client-ID" => config.client_id,
            "Stability-Client-Version" => config.client_version,
          },
        ) do |faraday|
          faraday.request :authorization, "Bearer", -> { config.api_key }
          faraday.request :json
          faraday.request :retry, FARADAY_RETRY_OPTIONS
          faraday.adapter :typhoeus
        end
      end
    end
  end
end

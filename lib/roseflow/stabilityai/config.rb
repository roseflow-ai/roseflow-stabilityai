# frozen_string_literal: true

require "anyway_config"

module Roseflow
  module StabilityAI
    class Config < Anyway::Config
      config_name :stabilityai

      attr_config :api_key
      attr_config api_url: "https://api.stability.ai"
      attr_config client_id: "Roseflow Stability-AI Ruby Client"
      attr_config client_version: "0.1.0"

      required :api_key
    end
  end
end

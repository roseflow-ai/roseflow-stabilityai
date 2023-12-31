# frozen_string_literal: true

require_relative "./base_response"

module Roseflow
  module StabilityAI
    module Responses
      class TextToImageResponse < BaseResponse
        transform_keys { |key| key.to_s.underscore.to_sym }

        attribute :artifacts, Types::Array do
          attribute :base64, Types::String
          attribute :finish_reason, Types::String
          attribute :seed, Types::Integer
        end

        alias_method :images, :artifacts
      end
    end
  end
end

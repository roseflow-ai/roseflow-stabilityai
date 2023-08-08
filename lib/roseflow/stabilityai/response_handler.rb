# frozen_string_literal: true

require "roseflow/stabilityai/responses/text_to_image_response"
require "roseflow/stabilityai/responses/image_to_image_response"
require "roseflow/stabilityai/responses/upscale_response"
require "roseflow/stabilityai/responses/masking_response"

module Roseflow
  module StabilityAI
    class ResponseHandler
      def initialize(operation, response)
        @operation = operation
        @response = response
      end

      def call
        if response.success?
          handle_successful_response
        else
          handle_error_response
        end
      end

      private

      attr_reader :operation, :response

      def handle_successful_response
        json = JSON.parse(response.body)

        case operation.type
        when :text_to_image
          Responses::TextToImageResponse.new(json)
        when :image_to_image
          Responses::ImageToImageResponse.new(json)
        when :upscale
          Responses::UpscaleResponse.new(json)
        when :masking
          Responses::MaskingResponse.new(json)
        else
          raise ArgumentError, "Invalid operation: #{operation.type}"
        end
      end

      def handle_error_response
        Responses::ErrorResponse.from(
          code: response.status,
          operation: operation.type,
          body: JSON.parse(response.body),
        )
      end
    end
  end
end

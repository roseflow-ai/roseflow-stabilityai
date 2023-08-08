# frozen_string_literal: true

require_relative "operations/text_to_image"
require_relative "operations/image_to_image"
require_relative "operations/upscale"
require_relative "operations/masking"

module Roseflow
  module StabilityAI
    class OperationHandler
      OPERATION_CLASSES = {
        text_to_image: Operations::TextToImage,
        image_to_image: Operations::ImageToImage,
        upscale: Operations::Upscale,
        masking: Operations::Masking,
      }

      def initialize(operation, options = {})
        @operation = operation
        @options = options
      end

      def call
        operation_class.new(@options)
      end

      private

      def operation_class
        OPERATION_CLASSES.fetch(@operation) do
          raise ArgumentError, "Invalid operation: #{@operation}"
        end
      end
    end
  end
end

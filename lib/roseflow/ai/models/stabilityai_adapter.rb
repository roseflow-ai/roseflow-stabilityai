# frozen_string_literal: true

require "roseflow/ai/model_interface"
require "roseflow/ai/models/base_adapter"

module Roseflow
  module AI
    module Models
      class StabilityAIAdapter < BaseAdapter
        include ModelInterface

        def configuration
          @configuration ||= StabilityAI::Model::Configuration.new(engine_id: @model.name)
        end

        def call(operation, options, &block)
          @model.call(operation, options, &block)
        end

        def text_to_image(options = {})
          @model.call(:text_to_image, options)
        end

        def image_to_image(options = {})
          @model.call(:image_to_image, options)
        end

        def upscale(options = {})
          @model.call(:upscale, options)
        end

        def masking(options = {})
          @model.call(:masking, options)
        end

        def operations
          @model.operations
        end
      end
    end
  end
end

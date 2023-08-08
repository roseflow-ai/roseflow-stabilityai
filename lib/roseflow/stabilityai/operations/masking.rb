# frozen_string_literal: true

require "roseflow/stabilityai/operations/base"

module Roseflow
  module StabilityAI
    module Operations
      class Masking < Base
        attribute :text_prompts, Types::Array do
          attribute :text, Types::String
          attribute :weight, Types::Float.default(1.0)
        end
        attribute :init_image, Types::String
        attribute :mask_image, Types::String
        attribute :mask_source, Types::String.default("INIT_IMAGE_ALPHA")
        attribute :cfg_scale, Types::Integer.default(7)
        attribute :clip_guidance_preset, Types::String.default("NONE")
        attribute? :sampler, Types::String
        attribute :samples, Types::Integer.default(1)
        attribute :seed, Types::Integer.default(0)
        attribute :steps, Types::Integer.default(50)
        attribute :style_preset, Types::String.default("photographic")

        def type
          :masking
        end
      end
    end
  end
end

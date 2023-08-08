# frozen_string_literal: true

require_relative "base"

module Roseflow
  module StabilityAI
    module Operations
      class TextToImage < Base
        attribute :height, Types::Integer.default(512)
        attribute :width, Types::Integer.default(512)
        attribute :text_prompts, Types::Array do
          attribute :text, Types::String
          attribute :weight, Types::Float.default(1.0)
        end
        attribute :cfg_scale, Types::Integer.default(7)
        attribute :clip_guidance_preset, Types::String.default("NONE")
        attribute? :sampler, Types::String
        attribute :samples, Types::Integer.default(1)
        attribute :seed, Types::Integer.default(0)
        attribute :steps, Types::Integer.default(50)
        attribute? :style_preset, Types::String.default("photographic")

        def type
          :text_to_image
        end

        def path
          "/v1/generation/#{engine_id}/text-to-image"
        end
      end
    end
  end
end

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

        def path
          "/v1/generation/#{engine_id}/image-to-image/masking"
        end

        def excluded_keys
          [:path, :engine_id, :text_prompts, :mask_image]
        end

        def body
          to_h.except(*excluded_keys).merge(
            init_image: Faraday::Multipart::ParamPart.new(
              init_image,
              "image/png",
            ),
            # mask_image: Faraday::Multipart::ParamPart.new(
            #   mask_image,
            #   "image/png",
            # ),
            text_prompts: text_prompts.each_with_index.map do |item, index|
              [index, item.to_h]
            end.to_h,
          )
        end

        def type
          :masking
        end
      end
    end
  end
end

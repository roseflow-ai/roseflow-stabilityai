# frozen_string_literal: true

require "roseflow/stabilityai/operations/base"

module Roseflow
  module StabilityAI
    module Operations
      class ImageToImage < Base
        attribute :text_prompts, Types::Array do
          attribute :text, Types::String
          attribute :weight, Types::Float.default(1.0)
        end
        attribute :init_image, Types::String
        attribute :init_image_mode, Types::String.default("IMAGE_STRENGTH")
        attribute :image_strength, Types::Float.default(0.35)
        attribute :cfg_scale, Types::Integer.default(7)
        attribute :clip_guidance_preset, Types::String.default("NONE")
        attribute? :sampler, Types::String
        attribute :samples, Types::Integer.default(1)
        attribute :seed, Types::Integer.default(0)
        attribute :style_preset, Types::String.default("photographic")

        def path
          "/v1/generation/#{engine_id}/image-to-image"
        end

        def multipart?
          true
        end

        def type
          :image_to_image
        end

        def excluded_keys
          [:path, :engine_id, :text_prompts]
        end

        def body
          initial = to_h.except(*excluded_keys)
          initial.merge(
            init_image: Faraday::Multipart::ParamPart.new(
              init_image,
              "image/png",
            ),
            text_prompts: text_prompts.each_with_index.map do |item, index|
              [index, item.to_h]
            end.to_h,
          )
        end
      end
    end
  end
end

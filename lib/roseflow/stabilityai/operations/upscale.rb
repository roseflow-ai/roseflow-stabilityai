# frozen_string_literal: true

require "roseflow/stabilityai/operations/base"

# TODO: Very sharp operation class currently, needs to handle edge cases better.
module Roseflow
  module StabilityAI
    module Operations
      class Upscale < Base
        attribute :upscale_type, Types::String

        attribute? :esrgan do
          attribute :image, Types::String
          attribute? :width, Types::Integer
          attribute? :height, Types::Integer
        end

        attribute? :sdx4 do
          attribute :image, Types::String
          attribute? :width, Types::Integer
          attribute? :height, Types::Integer
          attribute :text_prompts, Types::Array do
            attribute :text, Types::String
            attribute :weight, Types::Float.default(1.0)
          end
          attribute :seed, Types::Integer.default(0)
          attribute :steps, Types::Integer.default(50)
          attribute :cfg_scale, Types::Integer.default(7)
        end

        def path
          "/v1/generation/#{engine_id}/image-to-image/upscale"
        end

        def excluded_keys
          [:path, :engine_id, :text_prompts, :upscale_type, :esrgan, :sdx4]
        end

        def body
          case upscale_type.to_sym
          when :sdx4
            sdx4_body
          when :esrgan
            esrgan_body
          end
        end

        def sdx4_body
          initial = to_h.except(*excluded_keys)
          sdx4.to_h.merge(
            image: Faraday::Multipart::ParamPart.new(
              sdx4.image,
              "image/png",
            ),
            text_prompts: sdx4.text_prompts.each_with_index.map do |item, index|
              [index, item.to_h]
            end.to_h,
          ).merge(initial)
        end

        def esrgan_body
          initial = to_h.except(*excluded_keys)
          esrgan.to_h.merge(
            image: Faraday::Multipart::ParamPart.new(
              esrgan.image,
              "image/png",
            ),
          ).merge(initial)
        end

        def type
          :upscale
        end
      end
    end
  end
end

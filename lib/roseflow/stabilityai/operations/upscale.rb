# frozen_string_literal: true

require "roseflow/stabilityai/operations/base"

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

        def type
          :upscale
        end
      end
    end
  end
end

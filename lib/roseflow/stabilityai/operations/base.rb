# frozen_string_literal: true

module Roseflow
  module StabilityAI
    module Operations
      class Base < Dry::Struct
        transform_keys(&:to_sym)

        attribute :engine_id, Types::String

        def excluded_keys
          [:path]
        end

        def multipart?
          true
        end

        def body
          to_h.except(*excluded_keys)
        end
      end
    end
  end
end

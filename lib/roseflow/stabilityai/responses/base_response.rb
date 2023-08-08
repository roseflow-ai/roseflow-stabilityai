# frozen_string_literal: true

require "dry/struct"

module Roseflow
  module StabilityAI
    module Responses
      class BaseResponse < Dry::Struct
        transform_keys(&:to_sym)

        def success?
          true
        end
      end
    end
  end
end

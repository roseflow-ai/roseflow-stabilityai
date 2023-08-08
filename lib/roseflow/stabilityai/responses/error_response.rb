# frozen_string_literal: true

require "dry/struct"

module Roseflow
  module StabilityAI
    module Responses
      class ErrorResponse < Dry::Struct
        transform_keys(&:to_sym)

        attribute :code, Types::Integer
        attribute :operation, Types::String

        def success?
          false
        end

        # TODO: Implement this method
        def self.from(code: nil, operation: nil, body: nil)
        end
      end
    end
  end
end

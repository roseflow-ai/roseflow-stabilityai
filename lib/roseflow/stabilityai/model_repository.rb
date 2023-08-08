# frozen_string_literal: true

require "active_support/core_ext/module/delegation"

module Roseflow
  module StabilityAI
    class ModelRepository
      attr_reader :models

      delegate :each, :all, :first, :last, to: :models

      def initialize(provider)
        @provider = provider
        @models = load_models
      end

      def find(name)
        @models.select { |model| model.name == name }.first
      end

      private

      attr_reader :provider

      def load_models
        provider.client.models.map do |model|
          Model.new(model, provider)
        end
      end
    end
  end
end

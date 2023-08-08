# frozen_string_literal: true

module Roseflow
  module StabilityAI
    class Provider
      def initialize(config = Config.new)
        @config = config
      end

      def models
        @models ||= ModelRepository.new(self)
      end

      def client
        @client ||= Client.new(config, self)
      end

      def call(operation, options, &block)
        models.find(options.fetch(:engine_id)).call(operation, options, &block)
      end

      private

      attr_reader :config
    end
  end
end

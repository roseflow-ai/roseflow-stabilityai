# frozen_string_literal: true

require "roseflow/stabilityai/operation_handler"
require "roseflow/stabilityai/response_handler"

module Roseflow
  module StabilityAI
    class Model
      attr_reader :name

      def initialize(model_config, provider = nil)
        @model_config = model_config
        @provider = provider
        assign_attributes
      end

      def call(operation, options)
        operation = OperationHandler.new(operation, options).call
        ResponseHandler.new(operation, client.post(operation)).call
      end

      private

      attr_reader :model_config
      attr_reader :provider

      def client
        @client ||= Client.new(provider.send(:config), provider)
      end

      def assign_attributes
        @name = model_config.fetch("id")
        @description = model_config.fetch("description")
        @descriptive_name = model_config.fetch("name")
        @type = model_config.fetch("type")
      end
    end
  end
end

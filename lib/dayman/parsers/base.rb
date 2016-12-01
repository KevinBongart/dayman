# frozen_string_literal: true

module Dayman
  module Parsers
    class Base
      def initialize(resource:, response:)
        @resource = resource
        @raw_response = response
      end

      private

      def parsed_response
        return if @raw_response.blank?

        JSON.parse(@raw_response).deep_symbolize_keys
      end

      def resource_class_for(item)
        item[:type].classify.safe_constantize
      end

      def response_item_to_object(item)
        return unless resource_class = resource_class_for(item)

        resource_class.new(item.slice(:id, :attributes))
      end
    end
  end
end

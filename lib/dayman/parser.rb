# frozen_string_literal: true

module Dayman
  class Parser
    def initialize(resource:, response:)
      @resource = resource
      @raw_response = response
    end

    def collection
      return [] if parsed_response.blank?

      parsed_response[:data].map do |item|
        response_item_to_object(item)
      end
    end

    def member
      return nil if parsed_response.blank?

      response_item_to_object(parsed_response[:data])
    end

    private

    def parsed_response
      return nil if @raw_response.blank?

      JSON.parse(@raw_response).deep_symbolize_keys
    end

    def resource_class_for(item)
      item[:type].classify.safe_constantize
    end

    def add_missing_attributes_to_resource_class(resource_class, attributes = [])
      attributes.each do |attribute|
        accessor_method = "#{attribute}="

        unless resource_class.respond_to?(accessor_method)
          resource_class.module_eval { attr_accessor attribute }
        end
      end
    end

    def response_item_to_object(item)
      resource_class = resource_class_for(item)
      add_missing_attributes_to_resource_class(resource_class, item[:attributes].keys)

      resource_class.new(item[:attributes].merge(id: item[:id]))
    end
  end
end

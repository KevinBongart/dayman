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
        @parsed_response ||= begin
          return if @raw_response.blank?
          JSON.parse(@raw_response).deep_symbolize_keys
        end
      end

      def resource_class_for(item)
        return if item.nil?

        ClassFinder.new(resource: @resource, type: item[:type]).find
      end

      def response_item_to_object(item)
        return unless resource_class = resource_class_for(item)

        puts resource_class
        resource_class.new(item.slice(:id, :attributes))
      end

      def build_relationship(resource, relationship_name, relationship_content)
        return unless resource.respond_to?(relationship_name)

        if relationship_content.is_a?(Array)
          build_collection_relationship(resource, relationship_name, relationship_content)
        else
          build_member_relationship(resource, relationship_name, relationship_content)
        end
      end

      def build_collection_relationship(resource, relationship_name, relationship_content)
        relationship_content.each do |relationship_item|
          included_item = find_included_item(relationship_item)
          next unless object = response_item_to_object(included_item)

          resource.send(relationship_name) << object
        end
      end

      def build_member_relationship(resource, relationship_name, relationship_content)
        included_item = find_included_item(relationship_content)
        return unless object = response_item_to_object(included_item)

        resource.send("#{relationship_name}=", object)
      end

      def find_included_item(relationship_item)
        return if parsed_response[:included].blank?

        parsed_response[:included].find do |e|
          e.slice(:id, :type) == relationship_item[:data].slice(:id, :type)
        end
      end
    end
  end
end

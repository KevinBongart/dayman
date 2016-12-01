# frozen_string_literal: true

require_relative 'base'

module Dayman
  module Parsers
    class CollectionParser < Base
      def parse
        return [] if parsed_response.blank?

        parsed_response[:data].map do |item|
          response_item_to_object(item).tap do |resource|
            item[:relationships]&.each do |relationship_name, relationship_content|
              parse_relationship(resource, relationship_name, relationship_content)
            end
          end
        end
      end

      private

      def parse_relationship(resource, relationship_name, relationship_content)
        return unless resource.respond_to?(relationship_name)

        if relationship_content.is_a?(Array)
          parse_collection_relationship(resource, relationship_name, relationship_content)
        else
          parse_member_relationship(resource, relationship_name, relationship_content)
        end
      end

      def parse_collection_relationship(resource, relationship_name, relationship_content)
        relationship_content.each do |relationship_item|
          included_item = find_included_item(relationship_item)

          if object = response_item_to_object(included_item)
            resource.send(relationship_name) << object
          end
        end
      end

      def parse_member_relationship(resource, relationship_name, relationship_content)
        included_item = find_included_item(relationship_content)

        if object = response_item_to_object(included_item)
          resource.send("#{relationship_name}=", object)
        end
      end

      def find_included_item(relationship_item)
        parsed_response[:included].find do |e|
          e.slice(:id, :type) == relationship_item[:data].slice(:id, :type)
        end
      end
    end
  end
end

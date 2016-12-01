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
              next unless resource.respond_to?(relationship_name)

              if relationship_content.is_a?(Array)
                relationship_content.each do |relationship_item|
                  included_item = parsed_response[:included].find do |e|
                    e.slice(:id, :type) == relationship_item[:data].slice(:id, :type)
                  end

                  resource.send(relationship_name) << response_item_to_object(included_item)
                end
              else
                included_item = parsed_response[:included].find do |e|
                  e.slice(:id, :type) == relationship_content[:data].slice(:id, :type)
                end

                resource.send("#{relationship_name}=", response_item_to_object(included_item))
              end
            end
          end
        end
      end
    end
  end
end

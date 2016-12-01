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
              build_relationship(resource, relationship_name, relationship_content)
            end
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative 'base'

module Dayman
  module Parsers
    class MemberParser < Base
      def parse
        return if parsed_response.blank?

        item = parsed_response[:data]
        response_item_to_object(item).tap do |resource|
          item[:relationships]&.each do |relationship_name, relationship_content|
            parse_relationship(resource, relationship_name, relationship_content)
          end
        end
      end
    end
  end
end

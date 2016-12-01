# frozen_string_literal: true

require_relative 'base'

module Dayman
  module Parsers
    class MemberParser < Base
      def parse
        return if parsed_response.blank?

        response_item_to_object(parsed_response[:data])
      end
    end
  end
end

# frozen_string_literal: true
module Dayman
  class Request
    module Pagination
      # http://jsonapi.org/format/#fetching-pagination
      def limit(size)
        @page_size = size

        self
      end

      private

      def pagination_to_query_parameters
        return {} if page_size.blank?

        { page: { size: page_size } }
      end
    end
  end
end

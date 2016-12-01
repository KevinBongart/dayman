# frozen_string_literal: true
module Dayman
  class Request
    module Filters
      # http://jsonapi.org/format/#fetching-filtering
      def filter(conditions)
        filters.merge!(conditions)

        self
      end
      alias where filter

      private

      def filters_to_query_parameters
        return {} if filters.blank?

        filters.each_with_object({}) do |(key, value), hash|
          hash["filter[#{key}]"] = value
        end
      end
    end
  end
end

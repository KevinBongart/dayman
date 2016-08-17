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

        filters.map do |key, value|
          ["filter[#{key}]", value]
        end.to_h
      end
    end
  end
end

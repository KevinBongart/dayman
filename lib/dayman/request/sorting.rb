# frozen_string_literal: true
module Dayman
  class Request
    module Sorting
      SORT_ORDER_WHITELIST = [:asc, :desc].freeze

      # http://jsonapi.org/format/#fetching-sorting
      def sort(*args)
        Array(args).each do |sort_field|
          if sort_field.is_a?(Hash)
            sort_field, order = sort_field.first

            unless order.in?(SORT_ORDER_WHITELIST)
              raise ArgumentError, 'sort order must be :asc or :desc (defaults to :asc)'
            end
          else
            order = SORT_ORDER_WHITELIST.first
          end

          sort_fields.push(sort_field => order)
        end

        self
      end
      alias order sort

      private

      def sort_fields_to_query_parameters
        sort_fields = @sort_fields.uniq.compact.map do |sort_field|
          field, order = sort_field.first
          "#{'-' if order == :desc}#{field}"
        end

        if sort_fields.blank?
          {}
        else
          { sort: sort_fields.join(',') }
        end
      end
    end
  end
end

# frozen_string_literal: true
module Dayman
  class Request
    module Fields
      # http://jsonapi.org/format/#fetching-sparse-fieldsets
      def fields(*selected_fields)
        Array(selected_fields).flatten.each do |arg|
          if arg.is_a?(Hash)
            arg.each do |key, values|
              fieldsets[key] ||= []
              fieldsets[key] += Array(values)
            end
          else
            # TODO: use resource name
            key = resource.path.to_sym

            fieldsets[key] ||= []
            fieldsets[key].push(arg)
          end
        end

        self
      end
      alias select fields

      private

      def fieldsets_to_query_parameters
        return {} if fieldsets.blank?

        fieldsets.map do |key, values|
          ["fields[#{key}]", values.join(',')]
        end.to_h
      end
    end
  end
end

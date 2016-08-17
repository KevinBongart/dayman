# frozen_string_literal: true
module Dayman
  class Request
    module Includes
      # http://jsonapi.org/format/#fetching-includes
      def includes(*resources)
        Array(resources).each do |resource|
          included_resources.push(resource)
        end

        self
      end

      private

      def included_resources_to_query_parameters
        included_resources = @included_resources.uniq.compact
        return {} if included_resources.blank?

        resources = []
        included_resources.each do |resource|
          if resource.is_a?(Hash)
            resource.each do |key, values|
              Array(values).each do |value|
                resources.push([key, value].join('.'))
              end
            end
          else
            resources.push(resource)
          end
        end

        { include: resources.join(',') }
      end
    end
  end
end

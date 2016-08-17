module Dayman
  class Request
    attr_reader :resource,
      :filters

    def initialize(resource)
      @resource = resource
      @filters = {}
    end

    def all
      connection.get(resource.path, filters_to_query_parameters)
    end

    def find(id)
      connection.get([resource.path, id].join("/"))
    end

    def filter(conditions)
      filters.merge!(conditions)

      self
    end
    alias_method :where, :filter

    private

    def connection
      Faraday.new(url: resource.site)
    end

    def filters_to_query_parameters
      filters.map do |key, value|
        ["filter[#{key}]", value]
      end.to_h
    end
  end
end

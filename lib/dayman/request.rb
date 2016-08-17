# frozen_string_literal: true
module Dayman
  class Request
    attr_reader :resource,
      :filters,
      :included_resources

    def initialize(resource)
      @resource = resource
      @filters = {}
      @included_resources = []
    end

    def all
      connection.get(resource.path, query_parameters)
    end

    def find(id)
      connection.get([resource.path, id].join('/'))
    end

    def filter(conditions)
      filters.merge!(conditions)

      self
    end
    alias where filter

    def includes(*resources)
      Array(resources).each do |resource|
        included_resources.push(resource)
      end

      self
    end

    private

    def connection
      Faraday.new(url: resource.site)
    end

    def query_parameters
      params = {}

      params.merge!(filters_to_query_parameters)
      params.merge!(included_resources_to_query_parameters)
    end

    def filters_to_query_parameters
      return {} if filters.blank?

      filters.map do |key, value|
        ["filter[#{key}]", value]
      end.to_h
    end

    def included_resources_to_query_parameters
      included_resources = @included_resources.uniq.compact
      return {} if included_resources.blank?

      resources = []
      included_resources.each do |resource|
        if resource.is_a?(Hash)
          resource.each do |key, value|
            Array(value).each do |e|
              resources.push([key, e].join('.'))
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
